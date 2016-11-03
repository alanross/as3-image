package com.ar.image.effect
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Water
	{
		private var _matrix:Matrix;

		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _bmdTemp:BitmapData;
		private var _bmdDraw:BitmapData;
		private var _bmdLast:BitmapData;

		private var _colorizing:ColorTransform;
		private var _convolution:ConvolutionFilter;
		private var _displacement:DisplacementMapFilter;

		private var _fade:Number = 0;
		private var _fadeStep:Number;
		private var _density:Number;
		private var _intensity:Number = 128;
		private var _strength:Number;
		private var _size:int;

		private var _canvas:Sprite;
		private var _splashPos:Point;
		private var _splash:Boolean;

		/**
		 * Creates a new instance of Water.
		 */
		public function Water( input:BitmapData, output:BitmapData, strength:Number = 1.0, density:Number = 2.0, fading:Number = 0.5, size:int = 3 )
		{
			_strength = strength;
			_fadeStep = fading;
			_density = density;
			_size = size;

			_splashPos = new Point();

			_matrix = new Matrix();
			_matrix.scale( _density, _density );

			_input = input;
			_output = output;

			var sw:int = _input.width / _density;
			var sh:int = _input.height / _density;

			_bmdTemp = new BitmapData( sw, sh, false, 0x800000 );
			_bmdDraw = new BitmapData( sw, sh, false, 0x800000 );
			_bmdLast = new BitmapData( sw, sh, false, 0x800000 );

			_colorizing = new ColorTransform( 0.995 /*multiplier*/, 0.995, 0.995, 1, 2 /*offset*/, 2, 2, 0 );
			_convolution = new ConvolutionFilter( 3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1], 9 );
			_displacement = new DisplacementMapFilter( _output, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED, _intensity, _intensity );

			_canvas = new Sprite();
			_canvas.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		/**
		 * @private
		 */
		private function onEnterFrame( event:Event ):void
		{
			_canvas.graphics.clear();
			_canvas.graphics.lineStyle( 1, 0x000000 );

			if( _splash )
			{
				_fade = 0;

				var d:Number = 1.0 / _density;

				_canvas.graphics.drawCircle( _splashPos.x * d, _splashPos.y * d, _size );

				if( _displacement.scaleX < ( _intensity - 1 ) )
				{
					_displacement.scaleX++;
				}
			}
			else
			{
				_fade += _fadeStep;

				if( _fade > _intensity )
				{
					if( _displacement.scaleX > 1 )
					{
						_displacement.scaleX--;
					}
					else
					{
						_displacement.scaleX = .25;
					}
				}
			}

			_displacement.scaleY = _displacement.scaleX;

			_bmdDraw.draw( _canvas );
			_bmdTemp.applyFilter( _bmdDraw, _bmdDraw.rect, _bmdDraw.rect.topLeft, _convolution );
			_bmdTemp.draw( _bmdTemp, null, null, BlendMode.ADD );
			_bmdTemp.draw( _bmdLast, null, null, BlendMode.DIFFERENCE );
			_bmdTemp.draw( _bmdTemp, null, _colorizing );
			_output.draw( _bmdTemp, _matrix, null, null, null, true );
			_output.applyFilter( _input, _input.rect, _input.rect.topLeft, _displacement );
			_bmdLast = _bmdDraw;
			_bmdDraw = _bmdTemp.clone(); //feedback loop

			if( _displacement.scaleX <= 0 )
			{
				_bmdDraw = new BitmapData( _input.width / _density, _input.height / _density, false, 0x800000 );
				_bmdLast = new BitmapData( _input.width / _density, _input.height / _density, false, 0x800000 );

				_displacement.scaleX = _displacement.scaleY = _intensity;
			}
		}

		/**
		 * Start a splash
		 */
		public function start( x:Number, y:Number ):void
		{
			_splashPos.x = x;
			_splashPos.y = y;
			_splash = true;
		}

		/**
		 * update a splash
		 */
		public function update( x:Number, y:Number ):void
		{
			_splashPos.x = x;
			_splashPos.y = y;
		}

		/**
		 * Stop playing around.
		 */
		public function end( x:Number, y:Number ):void
		{
			_splashPos.x = x;
			_splashPos.y = y;
			_splash = false;
		}

		/**
		 * Creates and returns a string representation of the Water object.
		 */
		public function toString():String
		{
			return "[Water]";
		}
	}
}