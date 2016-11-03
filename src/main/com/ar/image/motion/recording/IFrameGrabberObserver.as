package com.ar.image.motion.recording
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IFrameGrabberObserver
	{
		/**
		 * Called each time a new image was grabbed
		 */
		function onFrameGrabbed( frame:BitmapData ):void;

		/**
		 * Called when the grabbing process stopped.
		 */
		function onFrameGrabStopped( frames:Vector.<BitmapData> ):void
	}
}