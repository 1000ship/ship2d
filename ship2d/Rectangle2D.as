package ship2d {
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display3D.textures.Texture;
	import flash.geom.ColorTransform;
	import flash.display3D.VertexBuffer3D;
	
	public class Rectangle2D implements Object2D {

		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		public var width:Number;
		public var height:Number;
		public var alpha:Number;
		private var _texture:Texture = null;
		private var animObj:Object;
		public var scaleX:Number;
		public var scaleY:Number;
		public var colorTransform:ColorTransform;
		public var centerPoint:Point;
		
		public function clone ():Rectangle2D
		{
			var r:Rectangle2D = new Rectangle2D( x, y, width, height );
			r.rotation = rotation;
			r.alpha = alpha
			r._texture = _texture;
			r.animObj = animObj;
			r.scaleX = scaleX;
			r.scaleY = scaleY;
			r.colorTransform = colorTransform;
			r.centerPoint = centerPoint;
			return r;
		}
		
		public function Rectangle2D ( $x:Number, $y:Number, $width:Number, $height:Number ) {
			// constructor code
			x = $x;
			y = $y;
			rotation = 0;
			alpha = 1;
			width = $width;
			height = $height;
			scaleX = 1;
			scaleY = 1;
			centerPoint = new Point;
			colorTransform = new ColorTransform();
		}
		
		public function setCenterPoint ( $x:Number, $y:Number ):void
		{
			centerPoint.x = $x;
			centerPoint.y = $y;
		}
		
		public function setTexture ( $texture:IShip2DTexture ) :void
		{
			if( $texture is AnimationTexture )
			{
				_texture = AnimationTexture( $texture ).getTextureByFrame( 1 );
				animObj = {target:AnimationTexture($texture), totalFrame:AnimationTexture($texture).totalFrame, currentFrame:1, isPlay:true, isLoop:true};
			}
			else
			{
				_texture = $texture.texture;
				animObj = null;
			}
		}
		
		public function removeTexture ():void
		{
			_texture = null;
			animObj = null;
		}
		
		public function changeFrame ():void
		{
			if( animObj != null )
			{
				if( animObj.isPlay )
				{
					++animObj.currentFrame;
					if( animObj.totalFrame < animObj.currentFrame && animObj.isLoop )
					{
						animObj.currentFrame = 1;
					}
					else if ( !animObj.isLoop )
					{
						animObj.isPlay = false;
						animObj.currentFrame = animObj.totalFrame;
					}
					_texture = AnimationTexture(animObj.target).getTextureByFrame( animObj.currentFrame );
				}
			}
		}
		
		public function get isAnimationTexture ():Boolean
		{
			if( animObj == null )
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function gotoAndStop ( $index:uint ):void
		{
			animObj.currentFrame = $index;
			animObj.isPlay = false;
		}
		
		public function gotoAndPlay ( $index:uint ):void
		{
			animObj.currentFrame = $index;
			animObj.isPlay = true;
		}
		
		public function set isLoop (value:Boolean):void
		{
			animObj.isLoop = value;
		}
		
		public function get isPlay ():Boolean
		{
			return animObj.isPlay;
		}
		
		public function get isLoop ():Boolean
		{
			return animObj.isLoop;
		}
		
		public function get currentFrame ():uint
		{
			return animObj.currentFrame;
		}
		
		public function get totalFrame ():uint
		{
			return animObj.totalFrame;
		}
		
		public function get texture ():Texture
		{
			return _texture;
		}
		
		public function get hasTexture():Boolean
		{
			if( _texture == null )
			{
				return false;
			}
			return true;
		}
		
	}
	
}
