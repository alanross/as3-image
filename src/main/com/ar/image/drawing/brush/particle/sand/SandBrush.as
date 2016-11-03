package com.ar.image.drawing.brush.particle.sand
{
	import com.ar.image.drawing.brush.IBrush;
	import com.ar.image.drawing.brush.particle.PaintParticle;
	import com.ar.image.drawing.brush.particle.ParticleBrush;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SandBrush extends ParticleBrush implements IBrush
	{
		private var _radius:int;

		private var _particles:SandParticle;

		/**
		 * Creates a new instance of SandBrush.
		 */
		public function SandBrush( radius:int = 40 )
		{
			_radius = Math.sqrt( radius );

			var p:SandParticle;

			p = _particles = new SandParticle();

			var n:int = 5000;

			while( --n > -1 )
			{
				p = p.next = new SandParticle();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw( posX:int, posY:int, stroke:Boolean ):void
		{
			var p:SandParticle = _particles.next;

			do
			{
				--p.restLife;

				if( p.restLife < 0 )
				{
					if( stroke )
					{
						var r:int = _radius * Math.random();

						var t:Number = Math.random() * PaintParticle.PI2;

						var rx:Number = Math.sin( t );
						var ry:Number = Math.cos( t );

						p.x = posX + ( rx * r );
						p.y = posY + ( ry * r );

						p.dirX = rx;
						p.dirY = ry;
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
						p.x += p.dirX * ( _radius * Math.random() );
						p.y += p.dirY * ( _radius * Math.random() );

						p.apply( canvas );
					}
				}

				p = p.next;
			}
			while( p );
		}

		/**
		 * Creates and returns a string representation of the SandBrush object.
		 */
		override public function toString():String
		{
			return "[SandBrush]";
		}
	}
}

