package hxvlc.flixel;

#if flixel
#if !flixel_addons
#error 'Your project must use flixel-addons in order to use this class.'
#end
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Bytes;
import haxe.io.Path;
import hxvlc.externs.Types;
import hxvlc.openfl.Video;
import hxvlc.util.OneOfThree;
import sys.FileSystem;

/**
 * `FlxVideoBackdrop` is made for showing infinitely scrolling video backgrounds using FlxBackdrop.
 */
class FlxVideoBackdrop extends FlxBackdrop
{
	/**
	 * Whether flixel should automatically change the volume according to the flixel sound system current volume.
	 */
	public var autoVolumeHandle:Bool = true;

	/**
	 * The video bitmap.
	 */
	public var bitmap(default, null):Video;

	/**
	 * Creates an instance of the `FlxVideoBackdrop` class, used to create infinitely scrolling video backgrounds.
	 *
	 * @param repeatAxes The axes on which to repeat. The default, `XY` will tile the entire camera.
	 * @param spacingX Amount of spacing between tiles on the X axis.
	 * @param spacingY Amount of spacing between tiles on the Y axis.
	 */
	#if (flixel_addons >= "3.2.1")
	public function new(repeatAxes = XY, spacingX = 0.0, spacingY = 0.0):Void
	{
		super(repeatAxes, spacingX, spacingY);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new Video(false);
		bitmap.onOpening.add(() -> bitmap.role = LibVLC_Role_Game);
		bitmap.onFormatSetup.add(() -> loadGraphic(bitmap.bitmapData));
		bitmap.alpha = 0;

		FlxG.game.addChild(bitmap);
	}
	#else
	public function new(repeatAxes = XY, spacingX = 0, spacingY = 0):Void
	{
		super(repeatAxes, spacingX, spacingY);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new Video(false);
		bitmap.onOpening.add(() -> bitmap.role = LibVLC_Role_Game);
		bitmap.onFormatSetup.add(() -> loadGraphic(bitmap.bitmapData));
		bitmap.alpha = 0;

		FlxG.game.addChild(bitmap);
	}
	#end

	/**
	 * Call this function to load a video.
	 *
	 * @param location The local filesystem path or the media location url or the id of a open file descriptor or the bitstream input.
	 * @param options The additional options you can add to the LibVLC Media instance.
	 *
	 * @return `true` if the video loaded successfully or `false` if there's an error.
	 */
	public function load(location:OneOfThree<String, Int, Bytes>, ?options:Array<String>):Bool
	{
		if (bitmap == null)
			return false;

		if (FlxG.autoPause)
		{
			if (!FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.add(resume);

			if (!FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.add(pause);
		}

		if (!(location is Int) && !(location is Bytes))
		{
			if (FileSystem.exists(Path.join([Sys.getCwd(), location])))
				return bitmap.load(Path.join([Sys.getCwd(), location]), options);
		}

		return bitmap.load(location, options);
	}

	/**
	 * Call this function to play a video.
	 *
	 * @return `true` if the video started playing or `false` if there's an error.
	 */
	public function play():Bool
	{
		if (bitmap == null)
			return false;

		return bitmap.play();
	}

	/**
	 * Call this function to stop the video.
	 */
	public function stop():Void
	{
		if (bitmap != null)
			bitmap.stop();
	}

	/**
	 * Call this function to pause the video.
	 */
	public function pause():Void
	{
		if (bitmap != null)
			bitmap.pause();
	}

	/**
	 * Call this function to resume the video.
	 */
	public function resume():Void
	{
		if (bitmap != null)
			bitmap.resume();
	}

	/**
	 * Call this function to toggle the pause of the video.
	 */
	public function togglePaused():Void
	{
		if (bitmap != null)
			bitmap.togglePaused();
	}

	// Overrides
	public override function destroy():Void
	{
		if (FlxG.signals.focusGained.has(resume))
			FlxG.signals.focusGained.remove(resume);

		if (FlxG.signals.focusLost.has(pause))
			FlxG.signals.focusLost.remove(pause);

		super.destroy();

		if (bitmap != null)
		{
			bitmap.dispose();

			if (FlxG.game.contains(bitmap))
				FlxG.game.removeChild(bitmap);

			bitmap = null;
		}
	}

	public override function kill():Void
	{
		if (bitmap != null)
			bitmap.pause();

		super.kill();
	}

	public override function revive():Void
	{
		super.revive();

		if (bitmap != null)
			bitmap.resume();
	}

	public override function update(elapsed:Float):Void
	{
		#if FLX_SOUND_SYSTEM
		if (autoVolumeHandle && !bitmap.mute)
		{
			final curVolume:Int = Math.floor((FlxG.sound.muted ? 0 : 1) * FlxG.sound.volume * 100);

			if (bitmap.volume != curVolume)
				bitmap.volume = curVolume;
		}
		#end

		super.update(elapsed);
	}
}
#end
