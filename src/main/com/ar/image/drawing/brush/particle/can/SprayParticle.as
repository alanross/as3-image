package com.ar.image.drawing.brush.particle.can
{
	import com.ar.image.drawing.brush.particle.PaintParticle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class SprayParticle extends PaintParticle
	{
		public var next:SprayParticle;

		public var viscosity:Number;

		public var dist:int;

		public var size:int;
		public var speed:Number;

		/**
		 * Creates a new instance of SprayParticle.
		 */
		public function SprayParticle()
		{
		}

		/**
		 * Creates and returns a string representation of the SprayParticle object.
		 */
		override public function toString():String
		{
			return "[SprayParticle]";
		}
	}
}
