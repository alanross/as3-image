package com.ar.image.drawing.brush
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class BrushCanvas extends Sprite
	{
		private var _canvas:Bitmap;

		private var _brush:IBrush;
		private var _stroke:Boolean = false;

		/**
		 * Creates a new instance of BrushCanvas.
		 */
		public function BrushCanvas( canvasWidth:Number, canvasHeight:Number, backgroundColor:uint = 0xFFFFFFFF )
		{
			_canvas = new Bitmap( new BitmapData( canvasWidth, canvasHeight, true, backgroundColor ) );

			addChild( _canvas );
		}

		/**
		 * Set the brush to be used for painting.
		 */
		public function setBrush( brush:IBrush ):void
		{
			if( _brush != null )
			{
				_brush.unbind( _canvas.bitmapData );
				_brush = null;
			}

			_brush = brush;

			if( _brush != null )
			{
				_brush.bind( _canvas.bitmapData );
			}
		}

		/**
		 * Begin a brush stroke.
		 */
		public function beginStroke( posX:int, posY:int ):void
		{
			_stroke = true;
			_brush.beginStroke( posX, posY );
		}

		/**
		 * Update a brush stroke position.
		 */
		public function updateStroke( posX:int, posY:int ):void
		{
			if( _stroke )
			{
				_brush.updateStroke( posX, posY );
			}
		}

		/**
		 * End a brush stroke
		 */
		public function endStroke( posX:int, posY:int ):void
		{
			_stroke = false;
			_brush.endStroke( posX, posY );
		}

		/**
		 * The bitmap data on which the brush paints on to.
		 */
		public function get bitmapData():BitmapData
		{
			return _canvas.bitmapData;
		}

		/**
		 * Creates and returns a string representation of the BrushCanvas object.
		 */
		override public function toString():String
		{
			return "[BrushCanvas]";
		}
	}
}