package com.ar.image.fluid.multiphase
{
	import flash.display.BitmapData;

	/**
	 * Grant Kot, Multiphase Fluid : http://grantkot.com/Multiphase/Liquid.html
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class MultiphaseFluid
	{
		private static const NUM_PARTICLES:int = 5000;

		private var _particles:FluidParticle;
		private var _grid:Vector.<Vector.<FluidNode>>;
		private var _headNode:FluidNode;
		private var _canvas:BitmapData;
		private var _pixelBuffer:Vector.<uint>;
		private var _mx:Number = 0;
		private var _my:Number = 0;
		private var _mxPrev:int;
		private var _myPrev:int;

		private var _mdx:Number = 0;
		private var _mdy:Number = 0;

		private var _drag:Boolean = false;

		public function MultiphaseFluid()
		{
			_canvas = new BitmapData( 512, 512, false, 0x0 );

			_pixelBuffer = new Vector.<uint>( _canvas.width * _canvas.height, true );

			_grid = new Vector.<Vector.<FluidNode>>( 128, true );

			var node:FluidNode;
			var gridX:int;
			var gridY:int;

			for( gridX = 0; gridX < 128; gridX++ )
			{
				_grid[gridX] = new Vector.<FluidNode>( 128, true );

				for( gridY = 0; gridY < 128; gridY++ )
				{
					if( _headNode != null )
					{
						_grid[gridX][gridY] = node = node.next = new FluidNode();
					}
					else
					{
						_grid[gridX][gridY] = node = _headNode = new FluidNode();
					}
				}
			}

			for( gridX = 0; gridX < (128 - 2); gridX++ )
			{
				for( gridY = 0; gridY < (128 - 2); gridY++ )
				{
					_grid[gridX][gridY].n10 = _grid[gridX + 1][gridY + 0];
					_grid[gridX][gridY].n20 = _grid[gridX + 2][gridY + 0];
					_grid[gridX][gridY].n01 = _grid[gridX + 0][gridY + 1];
					_grid[gridX][gridY].n11 = _grid[gridX + 1][gridY + 1];
					_grid[gridX][gridY].n21 = _grid[gridX + 2][gridY + 1];
					_grid[gridX][gridY].n02 = _grid[gridX + 0][gridY + 2];
					_grid[gridX][gridY].n12 = _grid[gridX + 1][gridY + 2];
					_grid[gridX][gridY].n22 = _grid[gridX + 2][gridY + 2];
				}
			}

			var p:FluidParticle = _particles = new FluidParticle();

			var i:int = NUM_PARTICLES;

			while( --i > -1 )
			{
				var posX:int = 0.1 + 0.9 * (i & 127);
				var posY:int = 0.1 + 0.9 * ((i >> 7) & 127);

				if( posX < 25 )
				{
					p.gas = false;
					p.mass = 4.0;
				}
				else if( posX < 50 )
				{
					p.gas = true;
					p.mass = 3.5;
				}
				else if( posX < 75 )
				{
					p.gas = false;
					p.mass = 2.8;
				}
				else
				{
					p.gas = false;
					p.mass = 2.4;
				}

				p.rd = 1.0;
				p.k = 1.0;

				p.color = 0x00D0FF;
				p.x = posX + Math.random() + 4.0;
				p.y = posY + Math.random() + 4.0;

				p = p.next = new FluidParticle();
			}
		}

		private function clear():void
		{
			var node:FluidNode = _headNode;
			while( node != null )
			{
				node.clear();
				node = node.next;
			}
		}

		private function a():void
		{
			var p:FluidParticle = _particles;
			while( p != null )
			{
				var pcx:uint = (p.x - 0.5) >> 0;
				var pcy:uint = (p.y - 0.5) >> 0;

				var d:Number = pcx - p.x;
				p.px0 = 0.5 * d * d + 1.5 * d + 1.125;
				p.gx0 = d + 1.5;

				d += 1.0;
				p.px1 = -d * d + 0.75;
				p.gx1 = -2.0 * d;

				d += 1.0;
				p.px2 = 0.5 * d * d - 1.5 * d + 1.125;
				p.gx2 = d - 1.5;

				d = pcy - p.y;
				p.py0 = 0.5 * d * d + 1.5 * d + 1.125;
				p.gy0 = d + 1.5;

				d += 1.0;
				p.py1 = -d * d + 0.75;
				p.gy1 = -2.0 * d;

				d += 1.0;
				p.py2 = 0.5 * d * d - 1.5 * d + 1.125;
				p.gy2 = d - 1.5;

				//--------

				var node:FluidNode = p.node = _grid[pcx][pcy];

				var n00:FluidNode = node;
				var n01:FluidNode = node.n01;
				var n02:FluidNode = node.n02;
				var n10:FluidNode = node.n10;
				var n11:FluidNode = node.n11;
				var n12:FluidNode = node.n12;
				var n20:FluidNode = node.n20;
				var n21:FluidNode = node.n21;
				var n22:FluidNode = node.n22;

				n00.active = true;
				n01.active = true;
				n02.active = true;
				n10.active = true;
				n11.active = true;
				n12.active = true;
				n20.active = true;
				n21.active = true;
				n22.active = true;

				p.p00 = p.px0 * p.py0;
				p.p10 = p.px1 * p.py0;
				p.p20 = p.px2 * p.py0;
				p.p01 = p.px0 * p.py1;
				p.p11 = p.px1 * p.py1;
				p.p21 = p.px2 * p.py1;
				p.p02 = p.px0 * p.py2;
				p.p12 = p.px1 * p.py2;
				p.p22 = p.px2 * p.py2;

				var pm:Number = p.mass;

				n00.m += p.p00 * pm;
				n00.d += p.p00;
				n00.gx += p.gx0 * p.py0;
				n00.gy += p.px0 * p.gy0;

				n10.m += p.p10 * pm;
				n10.d += p.p10;
				n10.gx += p.gx1 * p.py0;
				n10.gy += p.px1 * p.gy0;

				n20.m += p.p20 * pm;
				n20.d += p.p20;
				n20.gx += p.gx2 * p.py0;
				n20.gy += p.px2 * p.gy0;

				n01.m += p.p01 * pm;
				n01.d += p.p01;
				n01.gx += p.gx0 * p.py1;
				n01.gy += p.px0 * p.gy1;

				n11.m += p.p11 * pm;
				n11.d += p.p11;
				n11.gx += p.gx1 * p.py1;
				n11.gy += p.px1 * p.gy1;

				n21.m += p.p21 * pm;
				n21.d += p.p21;
				n21.gx += p.gx2 * p.py1;
				n21.gy += p.px2 * p.gy1;

				n02.m += p.p02 * pm;
				n02.d += p.p02;
				n02.gx += p.gx0 * p.py2;
				n02.gy += p.px0 * p.gy2;

				n12.m += p.p12 * pm;
				n12.d += p.p12;
				n12.gx += p.gx1 * p.py2;
				n12.gy += p.px1 * p.gy2;

				n22.m += p.p22 * pm;
				n22.d += p.p22;
				n22.gx += p.gx2 * p.py2;
				n22.gy += p.px2 * p.gy2;

				//--------

				var pressure:Number;

				if( p.gas == false )
				{
					d = n10.d - n00.d;

					var C20:Number = 3.0 * d - n10.gx - 2.0 * n00.gx;
					var C30:Number = -2.0 * d + n10.gx + n00.gx;

					d = n01.d - n00.d;

					var C02:Number = 3.0 * d - n01.gy - 2.0 * n00.gy;
					var C03:Number = -2.0 * d + n01.gy + n00.gy;

					var csum1:Number = n00.d + n00.gy + C02 + C03;
					var csum2:Number = n00.d + n00.gx + C20 + C30;

					var C21:Number = 3.0 * n11.d - 2.0 * n01.gx - n11.gx - 3.0 * csum1 - C20;
					var C31:Number = -2.0 * n11.d + n01.gx + n11.gx + 2.0 * csum1 - C30;
					var C12:Number = 3.0 * n11.d - 2.0 * n10.gy - n11.gy - 3.0 * csum2 - C02;
					var C13:Number = -2.0 * n11.d + n10.gy + n11.gy + 2.0 * csum2 - C03;
					var C11:Number = n01.gx - C13 - C12 - n00.gx;

					var u:Number = p.x - pcx;
					var u2:Number = u * u;
					var u3:Number = u * u2;

					var v:Number = p.y - pcy;
					var v2:Number = v * v;
					var v3:Number = v * v2;

					var density:Number = n00.d + n00.gx * u + n00.gy * v + C20 * u2 + C02 * v2 + C30 * u3 + C03 * v3 + C21 * u2 * v + C31 * u3 * v + C12 * u * v2 + C13 * u * v3 + C11 * u * v;

					pressure = p.k * (density - p.rd);

					if( pressure > 2.0 )
					{
						pressure = 2.0;
					}

					pressure *= pm;
				}
				else
				{
					pressure = 1.5;
				}

				//--------

				var fx:Number = 0.0;
				var fy:Number = 0.0;

				if( p.x < 8 )
				{
					fx = pm * (8 - p.x);
				}
				else if( p.x > 128 - 8 )
				{
					fx = pm * (128 - 8 - p.x);
				}

				if( p.y < 8 )
				{
					fy = pm * (8 - p.y);
				}
				else if( p.y > 128 - 8 )
				{
					fy = pm * (128 - 8 - p.y);
				}

				//--------

				var vx:Number = (p.x - _mx);
				var vy:Number = (p.y - _my);
				if( vx < 0 )
				{
					vx = -vx;
				}
				if( vy < 0 )
				{
					vy = -vy;
				}

				if( (vx < 10.0) && (vy < 10.0) )
				{
					var weight:Number = p.mass * (1.0 - (vx / 10.0)) * (1.0 - (vy / 10.0));

					fx += weight * (_mdx - p.u);
					fy += weight * (_mdy - p.v);
				}

				//--------

				var phi:Number = p.px0 * p.py0;
				n00.ax += -((p.gx0 * p.py0) * pressure) + fx * phi;
				n00.ay += -((p.px0 * p.gy0) * pressure) + fy * phi;

				phi = (p.px0 * p.py1);
				n01.ax += -((p.gx0 * p.py1) * pressure) + fx * phi;
				n01.ay += -((p.px0 * p.gy1) * pressure) + fy * phi;

				phi = (p.px0 * p.py2);
				n02.ax += -((p.gx0 * p.py2) * pressure) + fx * phi;
				n02.ay += -((p.px0 * p.gy2) * pressure) + fy * phi;

				phi = (p.px1 * p.py0);
				n10.ax += -((p.gx1 * p.py0) * pressure) + fx * phi;
				n10.ay += -((p.px1 * p.gy0) * pressure) + fy * phi;

				phi = (p.px1 * p.py1);
				n11.ax += -((p.gx1 * p.py1) * pressure) + fx * phi;
				n11.ay += -((p.px1 * p.gy1) * pressure) + fy * phi;

				phi = (p.px1 * p.py2);
				n12.ax += -((p.gx1 * p.py2) * pressure) + fx * phi;
				n12.ay += -((p.px1 * p.gy2) * pressure) + fy * phi;

				phi = (p.px2 * p.py0);
				n20.ax += -((p.gx2 * p.py0) * pressure) + fx * phi;
				n20.ay += -((p.px2 * p.gy0) * pressure) + fy * phi;

				phi = (p.px2 * p.py1);
				n21.ax += -((p.gx2 * p.py1) * pressure) + fx * phi;
				n21.ay += -((p.px2 * p.gy1) * pressure) + fy * phi;

				phi = (p.px2 * p.py2);
				n22.ax += -((p.gx2 * p.py2) * pressure) + fx * phi;
				n22.ay += -((p.px2 * p.gy2) * pressure) + fy * phi;

				p = p.next;
			}
		}

		private function b():void
		{
			var node:FluidNode = _headNode;
			while( node != null )
			{
				if( node.active )
				{
					node.ax /= node.m;
					node.ay /= node.m;
					node.ay += 0.03;
				}
				node = node.next;
			}
		}

		private function c():void
		{
			var p:FluidParticle = _particles;
			while( p != null )
			{
				var node:FluidNode = p.node;

				var n00:FluidNode = node;
				var n01:FluidNode = node.n01;
				var n02:FluidNode = node.n02;
				var n10:FluidNode = node.n10;
				var n11:FluidNode = node.n11;
				var n12:FluidNode = node.n12;
				var n20:FluidNode = node.n20;
				var n21:FluidNode = node.n21;
				var n22:FluidNode = node.n22;

				p.u += (p.p00 * n00.ax + p.p10 * n10.ax + p.p20 * n20.ax + p.p01 * n01.ax + p.p11 * n11.ax + p.p21 * n21.ax + p.p02 * n02.ax + p.p12 * n12.ax + p.p22 * n22.ax);
				p.v += (p.p00 * n00.ay + p.p10 * n10.ay + p.p20 * n20.ay + p.p01 * n01.ay + p.p11 * n11.ay + p.p21 * n21.ay + p.p02 * n02.ay + p.p12 * n12.ay + p.p22 * n22.ay);

				var mu:Number = p.mass * p.u;
				var mv:Number = p.mass * p.v;

				n00.u += p.p00 * mu;
				n00.v += p.p00 * mv;

				n10.u += p.p10 * mu;
				n10.v += p.p10 * mv;

				n20.u += p.p20 * mu;
				n20.v += p.p20 * mv;

				n01.u += p.p01 * mu;
				n01.v += p.p01 * mv;

				n11.u += p.p11 * mu;
				n11.v += p.p11 * mv;

				n21.u += p.p21 * mu;
				n21.v += p.p21 * mv;

				n02.u += p.p02 * mu;
				n02.v += p.p02 * mv;

				n12.u += p.p12 * mu;
				n12.v += p.p12 * mv;

				n22.u += p.p22 * mu;
				n22.v += p.p22 * mv;

				p = p.next;
			}
		}

		private function d():void
		{
			var node:FluidNode = _headNode;
			while( node != null )
			{
				if( node.active )
				{
					node.u /= node.m;
					node.v /= node.m;
				}
				node = node.next;
			}
		}

		private function e():void
		{
			var p:FluidParticle = _particles;
			while( p != null )
			{
				var node:FluidNode = p.node;

				var gu:Number = p.p00 * node.u + p.p10 * node.n10.u + p.p20 * node.n20.u + p.p01 * node.n01.u + p.p11 * node.n11.u + p.p21 * node.n21.u + p.p02 * node.n02.u + p.p12 * node.n12.u + p.p22 * node.n22.u;
				var gv:Number = p.p00 * node.v + p.p10 * node.n10.v + p.p20 * node.n20.v + p.p01 * node.n01.v + p.p11 * node.n11.v + p.p21 * node.n21.v + p.p02 * node.n02.v + p.p12 * node.n12.v + p.p22 * node.n22.v;

				p.x += gu;
				p.y += gv;
				p.u += gu - p.u;
				p.v += gv - p.v;

				if( p.x < 2 )
				{
					p.x = 2.2;
					p.u = 0.0;
				}
				else if( p.x > (128 - 2) )
				{
					p.x = 128 - 2.2;
					p.u = 0.0;
				}

				if( p.y < 2 )
				{
					p.y = 2.2;
					p.v = 0.0;
				}
				else if( p.y > (128 - 2) )
				{
					p.y = 128 - 2.2;
					p.v = 0.0;
				}

				// -------------

				var c:uint = p.color;

				var px0:uint = (p.x * 4) >> 0;
				var py0:uint = (p.y * 4) >> 0;
				var px1:uint = ((p.x - p.u) * 4) >> 0;
				var py1:uint = ((p.y - p.v) * 4) >> 0;

				_pixelBuffer[px0 + (py0 << 9)] = c;
				_pixelBuffer[((px0 + px1) >> 1) + (((py0 + py1) >> 1) << 9)] = c;
				_pixelBuffer[px1 + (py1 << 9)] = c;

				p = p.next;
			}
		}

		public function startSplash( x: Number, y: Number ):void
		{
			_mx = _mxPrev = x * 0.25;
			_my = _myPrev = y * 0.25;
			_drag = true;
		}

		public function moveSplash( x: Number, y: Number):void
		{
			_mx = x * 0.25;
			_my = y * 0.25;
		}

		public function endSplash( x: Number, y: Number ):void
		{
			_drag = false;
		}

		public function update():void
		{
			if( _drag )
			{
				_mdx = _mx - _mxPrev;
				_mdy = _my - _myPrev;
				_mxPrev = _mx;
				_myPrev = _my;
			}

			clear();
			a();
			b();
			c();
			d();

			var pos:uint = _pixelBuffer.length;
			while( --pos > -1 )
			{
				_pixelBuffer[pos] = 0x1F1814;
			}

			e();

			_canvas.lock();
			_canvas.setVector( _canvas.rect, _pixelBuffer );
//			_canvas.applyFilter( _canvas, _canvas.rect, ZERO_POINT, _blur );
			_canvas.unlock();
		}

		public function get canvas():BitmapData
		{
			return _canvas;
		}

		public function toString():String
		{
			return "[MultiphaseFluid]";
		}
	}
}