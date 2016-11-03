package com.ar.image.drawing.brush.particle.fiber
{
	import com.ar.image.drawing.brush.IBrush;
	import com.ar.image.drawing.brush.particle.ParticleBrush;
	import com.ar.image.effect.Fiber;
	import com.ar.image.filter.sobel.SobelQuickFilter;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FiberBrush extends ParticleBrush implements IBrush
	{
		public static const PI2:Number = Math.PI * 2;

		private var _force:SobelQuickFilter;

		private var _fiber:Fiber;
		private var _radius:int;
		private var _density:int;
		private var _length:int;

		/**
		 * Creates a new instance of FiberBrush.
		 */
		public function FiberBrush( radius:int = 20, len:Number = 40.0, density:int = 20, bend:Number = 0.5, crinkle:Number = 0.5 )
		{
			_fiber = new Fiber( 4, len, 1, bend, crinkle );
			_force = new SobelQuickFilter();

			_radius = radius;
			_density = density;
			_length = len;
		}

		/**
		 * @inheritDoc
		 */
		override public function bind( bmd:BitmapData ):void
		{
			super.bind( bmd );

			_force.applyHVSeparate( bmd );
		}

		/**
		 * @inheritDoc
		 */
		override public function unbind( bmd:BitmapData ):void
		{
			super.unbind( bmd );

			_force = null;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw( posX:int, posY:int, stroke:Boolean ):void
		{
			_fiber.clear();

			if( stroke )
			{
				var r:Number;
				var t:Number;
				var x:int;
				var y:int;
				var color:int;
				var angle:Number;
				var len:int = _length / 2;

				for( var i:int = 0; i < _density; ++i )
				{
					t = Math.random() * PI2;
					r = Math.random() * _radius;
					x = posX + ( Math.sin( t ) * r );
					y = posY + ( Math.cos( t ) * r );

					color = canvas.getPixel( x, y );
					angle = _force.getForceRadian( x, y );

					_fiber.length = len + Math.random() * len;
					_fiber.apply( x, posY, color, angle );
				}
			}

			canvas.draw( _fiber.canvas );
		}

		/**
		 * Creates and returns a string representation of the FiberBrush object.
		 */
		override public function toString():String
		{
			return "[FiberBrush]";
		}
	}
}