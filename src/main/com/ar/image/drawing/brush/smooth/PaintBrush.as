package com.ar.image.drawing.brush.smooth
{
	import com.ar.image.drawing.brush.IBrush;

	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class PaintBrush extends AbstractSmoothBrush implements IBrush
	{
		private var _pos:Point;
		private var _bmd:BitmapData;
		private var _radius:int;

		/**
		 * Creates a new instance of PaintBrush.
		 */
		public function PaintBrush( color:uint = 0x43B4F5, size:int = 20 )
		{
			_radius = size * 0.5;

			_bmd = new BitmapData( size, size, true, 0x0 );
			_bmd.draw( createGradientCircle( _radius, color ), new Matrix( 1, 0, 0, 1, _radius, _radius ) );

			_pos = new Point();
		}

		/**
		 * @private
		 */
		private function createGradientCircle( radius:int, color:uint ):Shape
		{
			var shape:Shape = new Shape;
			var matrix:Matrix = new Matrix();

			matrix.createGradientBox( radius * 2, radius * 2, 0, -radius, -radius );

			shape.graphics.beginGradientFill( GradientType.RADIAL, [color, color], [1, 0], [0, 255], matrix );
			shape.graphics.drawCircle( 0, 0, radius );
			shape.graphics.endFill();

			return shape;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw( posX:int, posY:int ):void
		{
			_pos.x = posX - _radius;
			_pos.y = posY - _radius;

			canvas.copyPixels( _bmd, _bmd.rect, _pos, null, null, true );
		}

		/**
		 * Creates and returns a string representation of the PaintBrush object.
		 */
		override public function toString():String
		{
			return "[PaintBrush]";
		}
	}
}