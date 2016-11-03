package com.ar.image.effect
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class AlphaTrails implements IEffect
	{
		private const origin:Point = new Point();

		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _color:ColorTransform;

		/**
		 * Creates a new instance of AlphaTrails.
		 */
		public function AlphaTrails( input:BitmapData, output:BitmapData, alpha:Number = 0.85 )
		{
			_input = input;
			_output = output;
			_color = new ColorTransform( 1, 1, 1, alpha, 0, 0, 0 );
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			// destructive process, changing input, not just output
			_input.lock();
			_input.colorTransform( _input.rect, _color );
			_input.unlock();
			_output.copyPixels( _input, _input.rect, origin );
		}

		/**
		 * Creates and returns a string representation of the AlphaTrails object.
		 */
		public function toString():String
		{
			return "[AlphaTrails]";
		}
	}
}