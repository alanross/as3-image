package com.ar.image.fractals.mandelbrot
{
	import com.ar.math.Colors;
	import com.ar.math.Maths;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Mandelbrot
	{
		private const minX:Number = -2.5;
		private const maxX:Number = 1.0;

		private const minY:Number = -1.0;
		private const maxY:Number = 1.0;

		private var _width:int;
		private var _height:int;

		private var _maxIterations:int;
		private var _output:BitmapData;

		public function Mandelbrot( output:BitmapData, maxIterations:int = 100 )
		{
			_output = output;
			_maxIterations = maxIterations;
			_width = _output.width;
			_height = _output.height;
		}

		public function render( x:int, y:int, zoomFactor:Number = 1.0 ):void
		{
			x = Maths.clamp( x, 0, _width );
			y = Maths.clamp( y, 0, _height );

			var cx:Number = minX + x / _width * ( maxX - minX );
			var cy:Number = minY + y / _height * ( maxY - minY );

			var l:Number = ( minX / zoomFactor ) + cx;
			var r:Number = ( maxX / zoomFactor ) + cx;
			var t:Number = ( minY / zoomFactor ) + cy;
			var b:Number = ( maxY / zoomFactor ) + cy;

			for( var i:int = 0; i < _width; ++i )
			{
				for( var j:int = 0; j < _height; ++j )
				{
					var x0:Number = l + i / _width * ( r - l );
					var y0:Number = t + j / _height * ( b - t );

					_output.setPixel32( i, j, mandelbrot( x0, y0 ) );
				}
			}
		}

		private function mandelbrot( x0:Number, y0:Number ):int
		{
			var x:Number = 0;
			var y:Number = 0;

			var i:int = 0;

			while( x * x + y * y < 2 * 2 && i < _maxIterations )
			{
				var xTemp:Number = x * x - y * y + x0;

				y = 2 * x * y + y0;

				x = xTemp;

				i++;
			}

			return ( i < _maxIterations ) ? Colors.hsv2rgb( (i / _maxIterations) * 360, 1.0, 1.0 ) : 0;
		}

		public function toString():String
		{
			return "[Mandelbrot]";
		}
	}
}