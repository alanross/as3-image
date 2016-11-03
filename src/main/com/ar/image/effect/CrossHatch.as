package com.ar.image.effect
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class CrossHatch implements IEffect
	{
		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _canvas:Shape;
		private var _graphics:Graphics;
		private var _length:int;
		private var _spacing:int;

		private var _width:int;
		private var _height:int;
		private var _row:int = 0;

		/**
		 * Creates a new instance of CrossHatch.
		 */
		public function CrossHatch( input:BitmapData, output:BitmapData, len:int = 10, spacing:int = 1 )
		{
			_input = input;
			_output = output;

			_length = len;
			_spacing = spacing;

			_width = input.width;
			_height = input.height;

			_canvas = new Shape();
			_graphics = _canvas.graphics;
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			if( !_canvas.hasEventListener( Event.ENTER_FRAME ) )
			{
				_canvas.addEventListener( Event.ENTER_FRAME, process );
			}
		}

		/**
		 * @private
		 */
		private function process( event:Event ):void
		{
			_graphics.clear();

			var dir:int;
			var px:int = 0;
			var py:int = 0;

			const n:int = _width;

			for( var col:int = 0; col < n; col += _spacing )
			{
				px = col;
				py = _row;

				_graphics.moveTo( px, py );
				_graphics.lineStyle( 1, _input.getPixel( px, py ) );

				dir = ( Math.random() - Math.random() ) * _length;
				px += ( Math.random() > 0.5 ) ? dir : -dir;
				py += ( Math.random() > 0.5 ) ? dir : -dir;

				_graphics.lineTo( px, py );
			}

			_output.draw( _canvas );

			_row += _spacing;

			if( _row >= _height )
			{
				_row = 0;
				_canvas.removeEventListener( Event.ENTER_FRAME, process );
			}
		}

		/**
		 * Creates and returns a string representation of the CrossHatch object.
		 */
		public function toString():String
		{
			return "[CrossHatch]";
		}
	}
}