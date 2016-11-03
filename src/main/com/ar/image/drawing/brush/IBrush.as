package com.ar.image.drawing.brush
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IBrush
	{
		/**
		 * Attach the brush to the canvas.
		 */
		function bind( bmd:BitmapData ):void;

		/**
		 * Detach the brush to the canvas.
		 */
		function unbind( bmd:BitmapData ):void;

		/**
		 * Called when a stroke begins.
		 */
		function beginStroke( posX:int, posY:int ):void;

		/**
		 * Called when a stroke position is updated.
		 */
		function updateStroke( posX:int, posY:int ):void;

		/**
		 * Called when a stroke ends.
		 */
		function endStroke( posX:int, posY:int ):void;
	}
}