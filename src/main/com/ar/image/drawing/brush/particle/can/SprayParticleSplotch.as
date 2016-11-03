package com.ar.image.drawing.brush.particle.can
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SprayParticleSplotch extends SprayParticle
	{
		/**
		 * Creates a new instance of SprayParticleSplotch.
		 */
		public function SprayParticleSplotch( c:uint )
		{
			age = life = 1 + Math.random() * 10;
			size = 2;
			color = c;
			viscosity = Math.random() * 2;
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			var r:Number;
			var n:int = 100 * Math.random();

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
		 * Creates and returns a string representation of the SprayParticleSplotch object.
		 */
		override public function toString():String
		{
			return "[SprayParticleSplotch]";
		}
	}
}