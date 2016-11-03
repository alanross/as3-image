package com.ar.image.drawing.brush.particle.fur
{
	import com.ar.image.drawing.brush.particle.PaintParticle;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FurParticle extends PaintParticle
	{
		public var next:FurParticle;

		/**
		 * Creates a new instance of FurParticle.
		 */
		public function FurParticle()
		{
			life = 1 + ( 20 * Math.random() );
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			b.setPixel32( x, y, color );
		}

		/**
		 * Creates and returns a string representation of the FurParticle object.
		 */
		override public function toString():String
		{
			return "[FurParticle]";
		}
	}
}
