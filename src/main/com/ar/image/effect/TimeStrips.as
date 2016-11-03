package com.ar.image.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class TimeStrips implements IEffect
	{
		private const rect:Rectangle = new Rectangle();
		private const orig:Point = new Point();

		private const stripeBuffer:Vector.<BitmapData> = new Vector.<BitmapData>();
		private const stripeRect:Rectangle = new Rectangle();
		private const stripeOffset:Point = new Point();

		private var _output:BitmapData;
		private var _input:BitmapData;
		private var _index:int;

		/**
		 * Creates a new instance of TimeStrips.
		 */
		public function TimeStrips( input:BitmapData, output:BitmapData )
		{
			_input = input;
			_output = output;

			rect.width = _input.width;
			rect.height = _input.height;

			stripeBuffer.splice( 0, stripeBuffer.length );

			for( var i:int = 0; i < _input.height; ++i )
			{
				stripeBuffer.push( new BitmapData( _input.width, _input.height, false, 0x0 ) );
			}

			stripeRect.width = _input.width;
			stripeRect.height = 1;
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			_output.fillRect( rect, 0x0 );

			var bmd:BitmapData = stripeBuffer[ _index ];

			bmd.fillRect( rect, 0x0 );
			bmd.copyPixels( _input, rect, orig );

			var height:int = rect.height;

			for( var i:int = 0; i < height; ++i )
			{
				stripeRect.y = stripeOffset.y = i;
				_output.copyPixels( stripeBuffer[ ( _index + i ) % height ], stripeRect, stripeOffset );
			}

			_index = ( _index + 1 ) % height;
		}

		/**
		 * Creates and returns a string representation of the TimeStrips object.
		 */
		public function toString():String
		{
			return "[TimeStrips]";
		}
	}
}