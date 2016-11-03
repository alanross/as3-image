package com.ar.image.effect
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Bukeh implements IEffect
	{
		private const pool:Vector.<Blob> = new Vector.<Blob>();
		private const blobs:Vector.<Blob> = new Vector.<Blob>();

		private var _minBlobCount:int;
		private var _maxBlobCount:int;

		private var _input:BitmapData;
		private var _output:BitmapData;

		/**
		 * Creates a new instance of Bukeh.
		 */
		public function Bukeh( input:BitmapData, output:BitmapData, minBlobCount:int = 24, maxBlobCount:int = 24 )
		{
			_input = input;
			_output = output;

			_minBlobCount = minBlobCount;
			_maxBlobCount = maxBlobCount;

			for( var i:int = 0; i < maxBlobCount; ++i )
			{
				pool.push( new Blob() );
			}
		}

		/**
		 * @private
		 */
		private function createBlob( x:int, y:int, color:int ):void
		{
			if( pool.length == 0 )
			{
				return;
			}

			var blob:Blob = pool.pop();

			blob.reset( x, y, color );

			blobs.unshift( blob );
		}

		/**
		 * @private
		 */
		private function expireBlob( blob:Blob ):void
		{
			blobs.splice( blobs.indexOf( blob ), 1 );
			pool.push( blob );
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			_output.fillRect( _output.rect, 0x0 );

			var n:int = blobs.length;

			while( --n > -1 )
			{
				var blob:Blob = blobs[n];

				blob.paint( _output );

				if( blob.age == blob.lifeSpan )
				{
					expireBlob( blob );
				}
			}

			if( n < _minBlobCount && Math.random() > 0.8 )
			{
				var x:int = Math.random() * _input.width;
				var y:int = Math.random() * _input.height;
				var c:int = _input.getPixel( x, y );

				createBlob( x, y, c );
			}
		}

		/**
		 * Creates and returns a string representation of the Bukeh object.
		 */
		public function toString():String
		{
			return "[Bukeh]";
		}
	}
}

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

class Blob extends Shape
{
	private const coloring:ColorTransform = new ColorTransform( 1.0, 1.0, 1.0, 1.0, 0, 0, 0, 0 );
	private const matrix:Matrix = new Matrix();
	private const blur:BlurFilter = new BlurFilter( 0, 0, 2 );

	private var _x:Number;
	private var _y:Number;
	private var _scale:Number = 0;
	private var _color:int = 0;

	private var _dirX:Number = 0;
	private var _dirY:Number = 0;

	private var _lifeSpan:Number = 0;
	private var _age:Number = 0;

	/**
	 * Creates a new instance of Blob.
	 */
	public function Blob()
	{
		blur.quality = 1;
	}

	/**
	 * Reset blob
	 */
	public function reset( px:int, py:int, color:int ):void
	{
		_x = px;
		_y = py;
		_color = color;

		_dirX = Math.random() - Math.random();
		_dirY = Math.random() - Math.random();

		_scale = 0.25 + Math.random() * 4;

		_lifeSpan = 64 + Math.random() * 256;
		_age = 0;

		alpha = 1;

		blur.blurX = blur.blurY = 2 + Math.random() * 32;
		filters = [blur];

		graphics.clear();
		graphics.beginFill( 0x0, 0 );
		graphics.drawRect( 0, 0, 100, 100 );
		graphics.endFill();
		graphics.beginFill( _color, 0.6 + Math.random() * 0.4 );
		graphics.drawCircle( 50, 50, 50 );
		graphics.endFill();
		graphics.lineStyle( 2, _color );
		graphics.drawCircle( 50, 50, 50 );
	}

	/**
	 * Paint the blob to given canvas.
	 */
	public function paint( canvas:BitmapData ):void
	{
		_x += _dirX;
		_y += _dirY;

		_scale += 0.004;

		alpha = Math.sin( ( 1.0 - ( _age / _lifeSpan ) ) * Math.PI );

		matrix.identity();
		matrix.scale( _scale, _scale );
		matrix.translate( _x, _y );

		coloring.alphaMultiplier = alpha;

		canvas.draw( this, matrix, coloring, BlendMode.ADD );

		_age++;
	}

	/**
	 * The lifespan of the blob.
	 */
	public function get lifeSpan():int
	{
		return _lifeSpan;
	}

	/**
	 * The age of the blob.
	 */
	public function get age():int
	{
		return _age;
	}

	/**
	 * Creates and returns a string representation of the Blob object.
	 */
	override public function toString():String
	{
		return "[Blob]";
	}
}