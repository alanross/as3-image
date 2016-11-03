package com.ar.image.effect
{
	import com.ar.image.filter.sobel.SobelQuickFilter;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Fiberizer implements IEffect
	{
		private var _spacing:int;

		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _force:SobelQuickFilter;

		private var _width:int;
		private var _height:int;
		private var _row:int = 0;

		private var _fiber:Fiber;
		private var _canvas:Shape;

		/**
		 * Creates a new instance of Fiberizer.
		 */
		public function Fiberizer( input:BitmapData, output:BitmapData, len:Number = 25.0, bend:Number = 0.05, crinkle:Number = 0.02, spacing:int = 1 )
		{
			_input = input;
			_output = output;

			_force = new SobelQuickFilter();

			_width = input.width;
			_height = input.height;

			_fiber = new Fiber( 4, len, 1, bend, crinkle );
			_canvas = _fiber.canvas;

			_spacing = spacing;
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			if( !_canvas.hasEventListener( Event.ENTER_FRAME ) )
			{
				_force.applyHVSeparate( _input );
				_canvas.addEventListener( Event.ENTER_FRAME, process );
			}
		}

		/**
		 * @private
		 */
		private function process( event:Event ):void
		{
			_fiber.clear();

			var color:int;
			var angle:Number;

			for( var col:int = 0; col < _width; col += _spacing )
			{
				color = _input.getPixel( col, _row );
				angle = 360 * Math.random();//rad2deg( _force.getForceRadian( col, _row ) );

				_fiber.apply( col, _row, color, angle );
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
		 * Creates and returns a string representation of the Fiberizer object.
		 */
		public function toString():String
		{
			return "[Fiberizer]";
		}
	}
}