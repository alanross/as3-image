package com.ar.image.drawing.brush.particle.goo
{
	import com.ar.image.drawing.brush.particle.PaintParticle;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class GooParticle extends PaintParticle
	{
		public var next:GooParticle;

		public var viscosity:Number;

		public var distToOrigin:int;

		public var size:int;
		public var damping:int;

		/**
		 * Creates a new instance of GooParticle.
		 */
		public function GooParticle()
		{
			life = 1 + Math.random() * 200;

			size = Math.random() * 10;

			viscosity = 0.1;
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			const t:Number = size * ( restLife / life );
			const c:int = ( ( ( alpha * 0xFF ) << 24 ) | color );

			var r:Number;
			var n:int = 4;

			while( --n > -1 )
			{
				r = Math.random() * PI2;

				b.setPixel32( x + ( Math.sin( r ) * t ), y + ( Math.cos( r ) * t ), c );
			}
		}

		/**
		 * Creates and returns a string representation of the GooParticle object.
		 */
		override public function toString():String
		{
			return "[GooParticle]";
		}
	}
}
	