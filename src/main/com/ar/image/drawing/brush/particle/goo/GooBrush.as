package com.ar.image.drawing.brush.particle.goo
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
	public final class GooBrush extends ParticleBrush implements IBrush
	{
		private const blur:BlurFilter = new BlurFilter( 2, 2, 2 );

		private var _radius:int;

		private var _particles:GooParticle;

		private var _output:BitmapData;

		/**
		 * Creates a new instance of GooBrush.
		 */
		public function GooBrush( color:uint = 0x888888, radius:int = 100 )
		{
			_radius = radius;

			var p:GooParticle;

			p = _particles = new GooParticle();

			var f:Number = radius / 10;
			var n:int = 5000;

			while( --n > -1 )
			{
				p = p.next = new GooParticle();
				p.color = color;
				p.damping = Math.random() * f;
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
			var p:GooParticle = _particles.next;

			do
			{
				--p.restLife;

				if( p.restLife < 0 )
				{
					if( stroke )
					{
						var t:Number = Math.random() * PaintParticle.PI2;

						p.distToOrigin = _radius * Math.random();

						p.x = posX + ( Math.sin( t ) * p.distToOrigin );
						p.y = posY + ( Math.cos( t ) * p.distToOrigin );
					}
					else
					{
						p.x = -1;
						p.y = -1;
					}

					p.restLife = p.life;
				}
				else
				{
					if( p.x != -1 && p.y != -1 )
					{
						p.y += ( p.restLife / p.life ) * p.damping * p.viscosity;

						p.alpha = 1 - ( p.distToOrigin / _radius );

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
		 * Creates and returns a string representation of the GooBrush object.
		 */
		override public function toString():String
		{
			return "[GooBrush]";
		}
	}
}
	