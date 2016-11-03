package com.ar.image.drawing.brush.particle.fur
{
	import com.ar.image.drawing.brush.IBrush;
	import com.ar.image.drawing.brush.particle.PaintParticle;
	import com.ar.image.drawing.brush.particle.ParticleBrush;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FurBrush extends ParticleBrush implements IBrush
	{
		private var _radius:int;

		private var _particles:FurParticle;

		/**
		 * Creates a new instance of FurBrush.
		 */
		public function FurBrush( radius:int = 50 )
		{
			_radius = radius;

			var p:FurParticle;

			p = _particles = new FurParticle();

			var n:int = 5000;

			while( --n > -1 )
			{
				p = p.next = new FurParticle();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw( posX:int, posY:int, stroke:Boolean ):void
		{
			var p:FurParticle = _particles.next;

			do
			{
				--p.restLife;

				if( p.restLife < 0 )
				{
					if( stroke )
					{
						var t:Number = Math.random() * PaintParticle.PI2;
						var r:int = _radius * Math.random();

						p.x = posX + ( Math.sin( t ) * r );
						p.y = posY + ( Math.cos( t ) * r );

						p.color = canvas.getPixel32( p.x, p.y );

						p.dirX = Math.sin( t );
						p.dirY = Math.cos( t );
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
						p.x += p.dirX;
						p.y += p.dirY;

						p.apply( canvas );
					}
				}

				p = p.next;
			}
			while( p );
		}

		/**
		 * Creates and returns a string representation of the FurBrush object.
		 */
		override public function toString():String
		{
			return "[FurBrush]";
		}
	}
}
