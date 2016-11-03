package com.ar.image.drawing.brush.particle.can
{
	import com.ar.image.drawing.brush.IBrush;
	import com.ar.image.drawing.brush.particle.PaintParticle;
	import com.ar.image.drawing.brush.particle.ParticleBrush;

	import flash.display.BitmapData;
	import flash.filters.BlurFilter;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SprayBrush extends ParticleBrush implements IBrush
	{
		private const blur:BlurFilter = new BlurFilter( 1, 1, 3 );

		private var _output:BitmapData;

		private var _paintParticles:SprayParticle;

		private var _radius:int;

		/**
		 * Creates a new instance of SprayBrush.
		 */
		public function SprayBrush( color:uint = 0x888888, radius:int = 200 )
		{
			_radius = radius;

			var p:SprayParticle;

			p = _paintParticles = new SprayParticle();

			var n:int = 10000;
			while( --n > -1 )
			{
				p = p.next = new SprayParticleThick( color );
			}

			n = 3;
			while( --n > -1 )
			{
				p = p.next = new SprayParticleSplotch( color );
			}

			n = 50;
			while( --n > -1 )
			{
				p = p.next = new SprayParticleSpeckle( color );
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function bind( bmd:BitmapData ):void
		{
			super.bind( bmd );

			_output = new BitmapData( bmd.width, bmd.height, true, 0 );
		}

		/**
		 * @inheritDoc
		 */
		override public function unbind( bmd:BitmapData ):void
		{
			super.unbind( bmd );

			_output = null;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw( posX:int, posY:int, stroke:Boolean ):void
		{
			var p:SprayParticle = _paintParticles.next;

			var r:Number;

			do
			{
				++p.age;

				if( p.age >= p.life )
				{
					if( stroke )
					{
						p.dist = ( _radius * Math.random() ) / ( p.life );

						r = Math.random() * PaintParticle.PI2;

						p.x = posX + ( Math.sin( r ) * p.dist );
						p.y = posY + ( Math.cos( r ) * p.dist );

						p.speed = p.viscosity + ( p.life * 0.01 );
					}
					else
					{
						p.x = -1;
						p.y = -1;
					}

					p.age = 1;
				}
				else
				{
					if( p.x != -1 && p.y != -1 )
					{
						p.speed /= p.age * 0.5;
						p.y += p.speed;
						p.alpha = 0x33 * ( 1 - ( p.dist / _radius ) );

						p.apply( _output );
					}
				}

				p = p.next;

			}
			while( p );

			_output.applyFilter( _output, _output.rect, _output.rect.topLeft, blur );

			canvas.draw( _output );

			_output.fillRect( _output.rect, 0 );
		}

		/**
		 * Creates and returns a string representation of the SprayBrush object.
		 */
		override public function toString():String
		{
			return "[SprayBrush]";
		}
	}
}
