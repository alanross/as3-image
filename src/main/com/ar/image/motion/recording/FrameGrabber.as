package com.ar.image.motion.recording
{
	import com.ar.math.Maths;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * Time based image grabbing utility.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FrameGrabber
	{
		private var _frames:Vector.<BitmapData> = new Vector.<BitmapData>();

		private var _observer:IFrameGrabberObserver;

		private var _input:DisplayObject;

		private var _timeoutIdFrame:Number;
		private var _timeoutIdRecord:Number;
		private var _width:Number;
		private var _height:Number;
		private var _fps:int;
		private var _startTime:Number;
		private var _capturing:Boolean;

		/**
		 * Creates a new instance of FrameGrabber.
		 */
		public function FrameGrabber( input:DisplayObject, width:int, height:int, observer:IFrameGrabberObserver = null )
		{
			_input = input;
			_width = width;
			_height = height;
			_observer = observer;
		}

		/**
		 * Start grabbing images.
		 */
		public function start( fps:int = 15, numSeconds:int = -1 ):void
		{
			if( !_capturing )
			{
				_frames.splice( 0, _frames.length );

				_fps = Maths.clamp( fps, 1, 30 );

				_capturing = true;

				_startTime = getTimer();

				if( numSeconds > 0 )
				{
					_timeoutIdRecord = setTimeout( stop, numSeconds * 1000.0 );
				}

				capture();
			}
		}

		/**
		 * Stop grabbing images.
		 */
		public function stop():void
		{
			if( _capturing )
			{
				clearTimeout( _timeoutIdFrame );

				if( _observer )
				{
					_observer.onFrameGrabStopped( _frames );
				}

				_capturing = false;
			}
		}

		/**
		 * @private
		 */
		private function capture():void
		{
			var frame:BitmapData = new BitmapData( _width, _height, false, 0x0 );

			frame.draw( _input );

			_frames.push( frame );

			if( _observer )
			{
				_observer.onFrameGrabbed( frame );
			}

			// schedule next frame capturing
			var elapsed:int = getTimer() - _startTime;
			var next:int = ( _frames.length / _fps ) * 1000.0;
			var delta:int = next - elapsed;

			_timeoutIdFrame = setTimeout( capture, ( delta < 10 ) ? 10 : delta );
		}

		/**
		 * List containing all grabbed images
		 */
		public function get frames():Vector.<BitmapData>
		{
			return _frames;
		}

		/**
		 * Returns true if the grabbing process is active.
		 */
		public function isCapturing():Boolean
		{
			return _capturing;
		}

		/**
		 * Creates and returns a string representation of the FrameGrabber object.
		 */
		public function toString():String
		{
			return "[FrameGrabber]";
		}
	}
}