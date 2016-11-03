package com.ar.image.drawing.brush.particle.sand
{
	import com.ar.image.drawing.brush.particle.PaintParticle;
	import com.ar.math.Colors;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SandParticle extends PaintParticle
	{
		public var next:SandParticle;

		/**
		 * Creates a new instance of SandParticle.
		 */
		public function SandParticle()
		{
			var h:Number;
			var s:Number;
			var v:Number;

			if( Math.random() > 0.2 )
			{
				h = 40 + (10 * Math.random() );
				s = 0.1 + ( 0.25 * Math.random() );
				v = 0.65 + ( 0.35 * Math.random() );
			}
			else
			{
				h = (360 * Math.random() );
				s = 0.2 + ( 0.35 * Math.random() );
				v = 0.65 + ( 0.35 * Math.random() );
			}

			color = ( 0xFF << 24 ) | Colors.hsv2rgb( h, s, v );

			life = 1 + ( 10 * Math.random() );
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			b.setPixel32( x, y, color );
		}

		/**
		 * Creates and returns a string representation of the SandParticle object.
		 */
		override public function toString():String
		{
			return "[SandParticle]";
		}
	}
}
