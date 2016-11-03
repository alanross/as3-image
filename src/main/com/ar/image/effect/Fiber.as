package com.ar.image.effect
{
	import com.ar.math.Maths;

	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Fiber
	{
		public var numSegments:int;
		public var thickness:Number;
		public var length:Number;
		public var bendFactor:Number;
		public var crinkleFactor:Number;

		private var _canvas:Shape = new Shape();
		private var _graphics:Graphics = _canvas.graphics;

		/**
		 * Creates a new instance of Fiber.
		 */
		public function Fiber( segments:int = 4, len:Number = 20.0, thickness:Number = 1.0, bend:Number = 0.05, crinkle:Number = 0.05 )
		{
			this.numSegments = segments;
			this.length = len;
			this.thickness = thickness;
			this.bendFactor = bend;
			this.crinkleFactor = crinkle;
		}

		/**
		 * Render the fiber strand.
		 */
		public function apply( x:Number, y:Number, color:int, degree:int ):void
		{
			const alpha:Number = Math.random();
			const segLen:Number = length / numSegments;
			const segAng:Number = bendFactor * 360;
			const segCri:Number = crinkleFactor * 360;

			var inverse:Number;
			var radian:Number;

			_graphics.moveTo( x, y );

			for( var i:int = 0; i < numSegments; ++i )
			{
				radian = Maths.deg2rad( degree );

				x += Math.cos( radian ) * segLen;
				y += Math.sin( radian ) * segLen;

				degree += segAng + ( segCri * ( ( 1.0 - 2.0 * Math.random() ) ) );

				inverse = 1.0 - ( i / numSegments );

				_graphics.lineStyle( thickness * inverse, color, alpha * inverse );
				_graphics.lineTo( x, y );
			}
		}

		/**
		 * Clear the rendered fiber.
		 */
		public function clear():void
		{
			_graphics.clear();
		}

		/**
		 * The canvas the fiber is renderer to.
		 */
		public function get canvas():Shape
		{
			return _canvas;
		}

		/**
		 * Creates and returns a string representation of the Fiber object.
		 */
		public function toString():String
		{
			return "[EDrawHairLines]";
		}
	}
}