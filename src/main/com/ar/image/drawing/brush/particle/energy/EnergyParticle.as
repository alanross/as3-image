package com.ar.image.drawing.brush.particle.energy
{
	import com.ar.image.drawing.brush.particle.PaintParticle;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class EnergyParticle extends PaintParticle
	{
		public var next:EnergyParticle;

		public var energy:Number = 0;
		public var energyMax:Number = 0;
		public var color32: int = 0x0;

		/**
		 * Creates a new instance of EnergyParticle.
		 */
		public function EnergyParticle( color:int = 0x0 )
		{
			this.life = 1 + Math.random() * 50;
			this.color = color;
			restLife = 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function apply( b:BitmapData ):void
		{
			b.setPixel32( x, y, color32 );
		}

		/**
		 * Creates and returns a string representation of the EnergyParticle object.
		 */
		override public function toString():String
		{
			return "[EnergyParticle]";
		}
	}
}
