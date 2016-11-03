package com.ar.image.drawing.brush.particle.can
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SprayParticleSpeckle extends SprayParticle
	{
		/**
		 * Creates a new instance of SprayParticleSpeckle.
		 */
		public function SprayParticleSpeckle( c:uint )
		{
			age = life = 1 + Math.random() * 5;
			size = 1;
			color = c;
			viscosity = 1;
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			var r:Number;

			var n:int = 1;

			while( --n > -1 )
			{
				r = Math.random() * PI2;

				b.setPixel32(
						x + ( Math.sin( r ) * ( size * Math.random() ) ),
						y + ( Math.cos( r ) * ( size * Math.random() ) ),
						( alpha << 24 | color )
				);
			}
		}

		/**
		 * Creates and returns a string representation of the SprayParticleSpeckle object.
		 */
		override public function toString():String
		{
			return "[SprayParticleSpeckle]";
		}
	}
}