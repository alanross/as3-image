package com.ar.image.shader
{
	import flash.display.Shader;	
	
	/**
	 * @author Alan Ross
	 */
	public interface IShaderLoaderListener 
	{
		/**
		 * Called when pixel bender shader was loaded successfully.
		 */
		function onShaderLoadComplete( shader: Shader ): void;
	}
}
