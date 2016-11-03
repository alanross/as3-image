package com.ar.image.force
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class ForceParticle
	{
		public var next:ForceParticle;

		public var x:Number = -1;
		public var y:Number = -1;
		public var color:uint = 0x0;
		public var life:int = 1;
		public var age:int = 0;
		public var speed:Number = 1.0;
		public var angle:Number = 0.0;
		public var velocity:Number = 2.0;
		public var velocityX:Number;
		public var velocityY:Number;

		/**
		 * Creates a new instance of ForceParticle.
		 */
		public function ForceParticle( lifespan:int )
		{
			life = lifespan;

			velocityX = ( 1 - 2 * Math.random() ) * 3;
			velocityY = ( 1 - 2 * Math.random() ) * 3;
		}

		/**
		 * Paint the particle to the bitmap.
		 */
		public function paint( b:BitmapData ):void
		{
			b.setPixel32( x, y, color );
		}

		/**
		 * Creates and returns a string representation of the ForceParticle object.
		 */
		public function toString():String
		{
			return "[ForceParticle]";
		}
	}
}