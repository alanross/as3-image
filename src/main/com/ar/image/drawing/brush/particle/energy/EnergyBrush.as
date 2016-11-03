package com.ar.image.drawing.brush.particle.energy
{
	import com.ar.image.drawing.brush.IBrush;
	import com.ar.image.drawing.brush.particle.PaintParticle;
	import com.ar.image.drawing.brush.particle.ParticleBrush;
	import com.ar.math.Maths;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class EnergyBrush extends ParticleBrush implements IBrush
	{
		private var _particles:EnergyParticle;
		private var _output:BitmapData;
		private var _radius:int;
		private var _damping:Number;
		private var _lastPosX:int;
		private var _lastPosY:int;
		private var _maxPotential:Number = 50;

		/**
		 * Creates a new instance of EnergyBrush.
		 */
		public function EnergyBrush( color:int = 0x0, radius:int = 10, damping:Number = .80 )
		{
			_radius = radius;
			_damping = damping;

			var p:EnergyParticle;

			p = _particles = new EnergyParticle( color );

			var n:int = 2000;

			while( --n > -1 )
			{
				p = p.next = new EnergyParticle( color );
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
		override public function beginStroke( posX:int, posY:int ):void
		{
			super.beginStroke( posX, posY );

			_lastPosX = posX;
			_lastPosY = posY;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw( posX:int, posY:int, stroke:Boolean ):void
		{
			var p:EnergyParticle = _particles.next;

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

						var potential:Number = Maths.dist( posX, posY, _lastPosX, _lastPosY );
						var direction:Number = Math.atan2( ( posX - _lastPosX ) + ( p.x - posX ), ( posY - _lastPosY ) + ( p.y - posY ) );

						if( potential > _maxPotential )
						{
							potential = _maxPotential;
						}

						p.color32 = ( ( ( ( potential / _maxPotential) * 0xFF ) << 24 ) | p.color );

						p.energyMax = p.energy = ( Maths.dist( p.x, p.y, posX, posY ) * potential ) / _radius;

						p.dirX = Math.sin( direction );
						p.dirY = Math.cos( direction );
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
						p.energy *= _damping;
						p.x += p.energy * p.dirX;
						p.y += p.energy * p.dirY;

						if( p.energy < 0.1 || p.x < 0 || p.x > canvas.width || p.y < 0 || p.y > canvas.height )
						{
							p.restLife = 0;
						}
						else
						{
							p.apply( _output );
						}
					}
				}

				p = p.next;
			}
			while( p );

			canvas.draw( _output );

			_output.fillRect( _output.rect, 0 );

			_lastPosX = posX;
			_lastPosY = posY;
		}

		/**
		 * Creates and returns a string representation of the EnergyBrush object.
		 */
		override public function toString():String
		{
			return "[EnergyBrush]";
		}
	}
}
