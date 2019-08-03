package ship2d {
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3D;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class AnimationTexture implements IShip2DTexture {
		
		private var _texture:Texture;
		private var _totalFrame:uint;
		private var _rect:Rectangle;
		private var _textures:Vector.<Texture>;
		
		public function AnimationTexture ( ) {
			// constructor code
		}
		
		public function uploadByBitmapData ( $ship2dcontainer:Ship2DContainer, $bitmapData:Vector.<BitmapData> ):void
		{
			var context:Context3D = $ship2dcontainer.context;
			_textures = new Vector.<Texture>;
			_rect = new Rectangle( 0, 0, 0, 0 );
			for( var i:int = 0; i < $bitmapData.length; ++ i )
			{
				_texture = context.createTexture( $bitmapData[ i ].width, $bitmapData[ i ].height, 'bgra', true );
				_texture.uploadFromBitmapData( $bitmapData[ i ] );
				_textures.push( _texture );
				if(_rect.width < $bitmapData[i].width )
				{
					_rect.width = $bitmapData[i].width;
				}
				if( _rect.height < $bitmapData[ i ].height )
				{
					_rect.height = $bitmapData[ i ].height;
				}
			}
			_totalFrame = $bitmapData.length;
		}
		
		public function uploadByMovieClip ( $ship2dcontainer:Ship2DContainer, $movieClip:MovieClip, $size:int = 512, $range:Rectangle = null ):void
		{
			if( $range == null )
			{
				$range = MovieClipStatus.getRangeByMovieClip( $movieClip );
				//$range = new Rectangle( 0, 0, $movieClip.width, $movieClip.height );
			}
			_rect = $range;
			var matrix:Matrix = new Matrix;
			var context:Context3D = $ship2dcontainer.context;
			var bitmapData:BitmapData;
			_textures = new Vector.<Texture>;
			for( var i:int = 0; i < $movieClip.totalFrames; ++ i )
			{
				matrix.identity();
				$movieClip.gotoAndStop( i + 1 );
				bitmapData = new BitmapData( $size, $size, true, 0 );
				matrix.translate( $range.x *-1, $range.y *-1 );
				matrix.scale( $size / $range.width * $movieClip.scaleX, $size / $range.height * $movieClip.scaleY );
				bitmapData.draw( $movieClip, matrix );
				_texture = context.createTexture( $size, $size, 'bgra', true );
				_texture.uploadFromBitmapData( bitmapData );
				_textures.push( _texture );
			}
			_totalFrame = $movieClip.totalFrames;
		}
		
		public function get texture ():Texture
		{
			trace( 'AnimationTexture 에서는 texture를 사용하지 않습니다.' );
			trace( 'getTextureByFrame 으로 Texture로 받을 수 있습니다.' );
			return null;
		}
		
		public function get rect ():Rectangle
		{
			return _rect;
		}
		
		public function getTextureByFrame ( $frame:uint ):Texture
		{
			return _textures[ $frame - 1 ] as Texture;
		}
		
		public function get totalFrame ():uint
		{
			return _totalFrame;
		}

	}
	
}
