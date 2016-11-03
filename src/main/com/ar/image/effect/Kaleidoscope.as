package com.ar.image.effect
{
	import com.ar.math.Maths;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;

	/**
	 * Derived from http://www.flashandmath.com/flashcs4/kal3mir/kal3mir.html
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Kaleidoscope implements IEffect
	{
		private const numSlices:int = 6;

		private var _input:BitmapData;
		private var _output:BitmapData;

		private var _width:int;
		private var _height:int;
		private var _numCols:int;
		private var _numRows:int;

		private var _sliceLength:Number;
		private var _sliceHeight:Number;

		private var _slice1:Shape = new Shape();
		private var _slice2:Shape = new Shape();

		/**
		 * Creates a new instance of Kaleidoscope.
		 */
		public function Kaleidoscope( input:BitmapData, output:BitmapData, numMirrors:Number = 3 )
		{
			_input = input;
			_output = output;

			_width = _input.width;
			_height = _input.height;

			_sliceLength = _width / numMirrors;
			_sliceHeight = Math.tan( Math.PI / 3 ) * _sliceLength / 2;

			_numCols = 1 + ( _width / ( _sliceLength / 2 ) );
			_numRows = 1 + ( _height / ( _sliceLength / 4 ) );
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			const g1:Graphics = _slice1.graphics;
			const g2:Graphics = _slice2.graphics;

			const mat:Matrix = new Matrix( 1, 0, 0, 1, _width * 0.5, _height * 0.5 );

			g1.clear();
			g1.beginBitmapFill( _input, mat, true, true );
			g1.moveTo( 0, 0 );
			g1.lineTo( -_sliceLength / 2, -_sliceHeight );
			g1.lineTo( _sliceLength / 2, -_sliceHeight );
			g1.lineTo( 0, 0 );
			g1.endFill();

			mat.scale( -1, 1 );
			g2.clear();
			g2.beginBitmapFill( _input, mat, true, true );
			g2.moveTo( 0, 0 );
			g2.lineTo( -_sliceLength / 2, -_sliceHeight );
			g2.lineTo( _sliceLength / 2, -_sliceHeight );
			g2.lineTo( 0, 0 );
			g2.endFill();

			var sAngle:int = 360 / numSlices;
			var sX:int = 0;
			var sY:int = 0;
			var sOffsetX:int = 0;

			for( var i:int = 0; i < _numRows; i++ )
			{
				sOffsetX = ( i % 2 == 1 ) ? ( _sliceLength * 3 / 2 ) : 0;

				for( var j:int = 0; j < _numCols; j++ )
				{
					sX = _sliceLength + j * _sliceLength * 3;
					sY = i * _sliceHeight;

					for( var k:int = 0; k < numSlices; k++ )
					{
						mat.identity();
						mat.rotate( Maths.deg2rad( k * sAngle ) );
						mat.tx = sX - sOffsetX;
						mat.ty = sY;

						if( k % 2 == 0 )
						{
							_output.draw( _slice1, mat );
						}
						else
						{
							_output.draw( _slice2, mat );
						}
					}
				}
			}
		}

		/**
		 * Creates and returns a string representation of the Kaleidoscope object.
		 */
		public function toString():String
		{
			return "[Kaleidoscope]";
		}
	}
}