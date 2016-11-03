package com.ar.image.force
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class PerlinForce implements IForce
	{
		private static const CHANNEL:int = BitmapDataChannel.GREEN | BitmapDataChannel.BLUE;

		private const scale:Number = 4;
		private const p0:Point = new Point();
		private const p1:Point = new Point();
		private const octaves:Array = [ p0, p1 ];
		private const matrix:Matrix = new Matrix( scale, 0, 0, scale );

		private var _forceFieldS:BitmapData;
		private var _forceField:BitmapData;
		private var _forceSpeed:Number;

		/**
		 * Creates a new instance of PerlinForce.
		 */
		public function PerlinForce( width:int, height:int, speed:Number = 0.3 )
		{
			_forceSpeed = speed;
			_forceField = new BitmapData( width, height, true, 0x0 );
			_forceFieldS = new BitmapData( width / scale, height / scale, true, 0x0 );
		}

		/**
		 * Update the perlin noise
		 */
		public function update():void
		{
			p0.x += _forceSpeed;
			p0.y -= _forceSpeed;

			p1.x -= _forceSpeed;
			p1.y += _forceSpeed;

			_forceFieldS.perlinNoise( 32, 32, 2, 0xAABBCC, true, true, CHANNEL, true, octaves );
			_forceField.draw( _forceFieldS, matrix );
		}

		/**
		 * Returns as an radian force value calculated by the atan of the hor and ver values.
		 */
		public function getForceRadian( x:int, y:int ):int
		{
			const color:int = _forceField.getPixel( x, y );

			var fh:Number = ( color & 0xff ) - 127; //blue
			var fv:Number = ( ( color >> 8 ) & 0xff ) - 127; //green

			return Math.atan2( fh, fv );
		}

		/**
		 * Returns as an radian force value calculated by atan between hor and ver values.
		 */
		public function getForceAngle( x:int, y:int ):int
		{
			var value:Number = _forceField.getPixel( x, y ) / 0xFFFFFF;

			return value * 360.0;
		}

		/**
		 * The color value at given position
		 */
		public function getPixel( x:int, y:int ):int
		{
			return _forceField.getPixel( x, y );
		}

		/**
		 * The normalized color value at given position ranging between 0 and 1.
		 */
		public function getNormalized( x:int, y:int ):Number
		{
			return Number( _forceField.getPixel( x, y ) / 0xFFFFFF );
		}

		/**
		 * The perlin noise image.
		 */
		public function get bitmapData():BitmapData
		{
			return _forceField;
		}

		/**
		 * Creates and returns a string representation of the PerlinForce object.
		 */
		public function toString():String
		{
			return "[PerlinForce]";
		}
	}
}