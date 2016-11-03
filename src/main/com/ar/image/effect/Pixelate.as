package com.ar.image.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Pixelate implements IEffect
	{
		private const origin:Point = new Point();

		private var _input:BitmapData;
		private var _output:BitmapData;

		private var _region:Rectangle;
		private var _pixelSize:int;

		/**
		 * Creates a new instance of Pixelate.
		 */
		public function Pixelate( input:BitmapData, output:BitmapData, pixelSize:int = 10, region:Rectangle = null )
		{
			_input = input;
			_output = output;

			_pixelSize = pixelSize;

			if( region != null )
			{
				_region = new Rectangle( region.x, region.y, region.width, region.height );
			}
			else
			{
				_region = new Rectangle( 0, 0, input.width, input.height );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			var rx:int = _region.x;
			var ry:int = _region.y;
			var rw:int = _region.x + _region.width;
			var rh:int = _region.y + _region.height;

			var rect:Rectangle = new Rectangle( 0, 0, _pixelSize, _pixelSize );

			_output.copyPixels( _input, _input.rect, origin );

			for( var py:int = ry; py < rh; py += _pixelSize )
			{
				for( var px:int = rx; px < rw; px += _pixelSize )
				{
					rect.x = px;
					rect.y = py;

					_output.fillRect( rect, _input.getPixel32( px + _pixelSize * 0.5, py + _pixelSize * 0.5 ) );
				}
			}
		}

		/**
		 * Creates and returns a string representation of the Pixelate object.
		 */
		public function toString():String
		{
			return "[Pixelate]";
		}
	}
}