package com.ar.image.drawing.brush.particle
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class PaintParticle
	{
		public static const PI2:Number = Math.PI * 2;

		public var x:Number = -1;
		public var y:Number = -1;

		public var dirX:Number;
		public var dirY:Number;

		public var color:uint;
		public var alpha:Number;

		public var life:int;
		public var restLife:int;
		public var age:int;

		/**
		 * Creates a new instance of PaintParticle.
		 */
		public function PaintParticle()
		{
		}

		/**
		 * Draw the particle to the bitmap.
		 */
		public function apply( b:BitmapData ):void
		{
		}

		/**
		 * Creates and returns a string representation of the PaintParticle object.
		 */
		public function toString():String
		{
			return "[PaintParticle]";
		}
	}
}