package ship2d {
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3DTextureFormat;
	
	public class BitmapTexture implements IShip2DTexture {
		
		private var _texture:Texture;
		private var _bitmapData:BitmapData;

		public function BitmapTexture ( $target:BitmapData ) {
			// constructor code
			_bitmapData = $target;
		}
		
		public function upload ( $ship2dcontainer:Ship2DContainer ):void
		{
			_texture = $ship2dcontainer.context.createTexture( _bitmapData.width, _bitmapData.height, 'bgra', true );
			_texture.uploadFromBitmapData( _bitmapData );
		}
		
		public function get texture ():Texture
		{
			return _texture;
		}

	}
	
}
