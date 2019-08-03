package ship2d {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	public class ObjectTexture implements IShip2DTexture {

		private var _texture:Texture;
		private var _target:DisplayObject;
		private var matrix:Matrix;
		public var range:Rectangle;
		private var image:BitmapData;
		private var _size:int;
		private var alphaMaker:ColorTransform;
		
		public function get size ():int
		{
			return _size;
		}
		
		public function get texture ():Texture
		{
			return _texture;
		}
		
		public function get target ():DisplayObject
		{
			return _target;
		}

		public function ObjectTexture ( $displayObject:DisplayObject, $size:int = 1024, $range:Rectangle = null ) {
			// constructor code
			alphaMaker = new ColorTransform( 0, 0, 0, 0 );
			_target = $displayObject;
			matrix = new Matrix();
			if( $range == null )
			{
				range = MovieClipStatus.getDisplayObjectRect( $displayObject );
			}
			else
			{
				range = $range;
			}
			image = new BitmapData( $size, $size, true, 0 );
			_size = $size;
		}
		
		public function capture ():void
		{
			image.colorTransform( image.rect, alphaMaker );
			matrix.identity();
			matrix.translate( range.x *-1, range.y *-1 );
			matrix.scale( _size / range.width, _size / range.height );
			image.draw( _target, matrix );
		}
		
		public function upload ( $ship2dcontainer:Ship2DContainer, $autoCapture:Boolean = true ):void
		{
			if( $autoCapture )
			{
				capture();
			}
			if( _texture != null )
			{
				_texture.dispose();
			}
			_texture = $ship2dcontainer.context.createTexture( _size, _size, "bgra", true );
			_texture.uploadFromBitmapData( image );
		}

	}
	
}
