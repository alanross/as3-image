package com.ar.image.drawing.brush.smooth
{
	import com.ar.image.drawing.brush.IBrush;

	import flash.display.BitmapData;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class ShapeBrush extends AbstractSmoothBrush implements IBrush
	{
		private var _pos:Point;
		private var _bmd:BitmapData;
		private var _radius:int;

		/**
		 * Creates a new instance of ShapeBrush.
		 */
		public function ShapeBrush( shape:DisplayObject, color:uint = 0x43B4F5, size:int = 20 )
		{
			_radius = size * 0.5;

			var t:ColorTransform = new ColorTransform();
			t.color = color;
			shape.transform.colorTransform = t;

			var wrapper: Sprite = new Sprite();
			wrapper.addChild( shape );

			var scale:Number = size / shape.width;

			_bmd = new BitmapData( size, size, true, 0x0 );
			_bmd.draw( wrapper, new Matrix( scale, 0, 0, scale, 0, 0 ) );

			_pos = new Point();
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
		 * Creates and returns a string representation of the ShapeBrush object.
		 */
		override public function toString():String
		{
			return "[ShapeBrush]";
		}
	}
}