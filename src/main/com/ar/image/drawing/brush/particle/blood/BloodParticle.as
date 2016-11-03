package com.ar.image.drawing.brush.particle.blood
{
	import com.ar.image.drawing.brush.particle.PaintParticle;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class BloodParticle extends PaintParticle
	{
		public var next:BloodParticle;

		public var viscosity:Number;

		public var distToOrigin:int;

		public var size:int;

		/**
		 * Creates a new instance of BloodParticle.
		 */
		public function BloodParticle()
		{
			var maxDropLength:int = 40;
			var minDropLength:int = 20;

			life = 1 + Math.random() * ( ( Math.random() > 0.9 ) ? maxDropLength : minDropLength );

			size = Math.random() * 9;

			viscosity = 0.1;
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			const t:Number = size * ( restLife / life );
			const c:int = ( ( alpha << 24 ) | color );

			var r:Number;
			var n:int = 4;

			while( --n > -1 )
			{
				r = Math.random() * PI2;

				b.setPixel32( x + ( Math.sin( r ) * t ),  y + ( Math.cos( r ) * t ), c );
			}
		}

		/**
		 * Creates and returns a string representation of the BloodParticle object.
		 */
		override public function toString():String
		{
			return "[BloodParticle]";
		}
	}
}
