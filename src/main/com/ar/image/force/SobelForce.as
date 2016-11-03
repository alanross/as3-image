package com.ar.image.force
{
	import com.ar.image.filter.sobel.SobelQuickFilter;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SobelForce implements IForce
	{
		private var _force:SobelQuickFilter;

		/**
		 * Creates a new instance of SobelForce.
		 */
		public function SobelForce( input:BitmapData )
		{
			_force = new SobelQuickFilter();
			_force.apply( input );
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
			return _force.output;
		}

		/**
		 * Creates and returns a string representation of the SobelForce object.
		 */
		public function toString():String
		{
			return "[SobelForce]";
		}
	}
}