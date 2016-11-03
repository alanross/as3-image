package com.ar.image.force
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IForce
	{
		/**
		 * Update the force.
		 */
		function update():void

		/**
		 * Returns the bitmap data representation of the force
		 */
		function get bitmapData():BitmapData;
	}
}