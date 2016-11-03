package com.ar.image.force
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class ImageForce implements IForce
	{
		private var _image:BitmapData;

		/**
		 * Creates a new instance of ImageForce.
		 */
		public function ImageForce( image:BitmapData )
		{
			_image = image;
		}

		/**
		 * @inheritDoc
		 */
		public function update():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function get bitmapData():BitmapData
		{
			return _image;
		}

		/**
		 * Creates and returns a string representation of the ImageForce object.
		 */
		public function toString():String
		{
			return "[ImageForce]";
		}
	}
}