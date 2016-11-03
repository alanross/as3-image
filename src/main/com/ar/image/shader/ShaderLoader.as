package com.ar.image.shader
{
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.display.ShaderInput;
	import flash.display.ShaderParameter;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * Loads a pixel bender shader.
	 *
	 * @author Alan Ross
	 */
	public class ShaderLoader
	{
		private var _shader:Shader;

		private var _loader:URLLoader;

		private var _listener:IShaderLoaderListener;

		/**
		 * Creates a new instance of ShaderLoader.
		 */
		public function ShaderLoader( shaderUrl:String, listener:IShaderLoaderListener )
		{
			_listener = listener;

			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener( Event.COMPLETE, onLoadComplete );
			_loader.load( new URLRequest( shaderUrl ) );
		}

		/**
		 * @private
		 */
		private function onLoadComplete( event:Event ):void
		{
			_shader = new Shader( _loader.data );

			getShaderInfo( _shader );

			_listener.onShaderLoadComplete( _shader );
		}

		/**
		 * @private
		 */
		private function getShaderInfo( shader:Shader ):String
		{
			const shaderData:ShaderData = shader.data;
			const input:Vector.<ShaderInput> = new Vector.<ShaderInput>();
			const param:Vector.<ShaderParameter> = new Vector.<ShaderParameter>();
			const meta:Vector.<String> = new Vector.<String>();

			for( var prop:String in shaderData )
			{
				if( shaderData[ prop ] is ShaderInput )
				{
					input[input.length] = shaderData[ prop ];
				}
				else if( shaderData[prop] is ShaderParameter )
				{
					param[ param.length ] = shaderData[ prop ];
				}
				else
				{
					meta[ meta.length ] = shaderData[ prop ];
				}
			}

			const info:String = "Shader: inputs:" + input + ", params:" + param + ", metas:" + meta;

			return info;
		}

		/**
		 * Creates and returns a string representation of the ShaderLoader object.
		 */
		public function toString():String
		{
			return "[ShaderLoader]";
		}
	}
}
