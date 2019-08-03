package ship2d {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MovieClipStatus {

		static public function getMovieClipRect ( $mc:MovieClip ):Rectangle2D
		{
			var rect:Rectangle = getRangeByMovieClip( $mc );
			var r2d:Rectangle2D = new Rectangle2D( 0, 0, rect.width, rect.height );
			r2d.x = $mc.x;
			r2d.y = $mc.y;
			//r2d.setCenterPoint( (rect.x * 2 + rect.width)/2 *-1, (rect.y * 2 + rect.height)/2 *-1 );
			//r2d.setCenterPoint( rect.width * -1 / 2 - rect.x, rect.height * -1 / 2 - rect.y );
			//r2d.setCenterPoint( $mc.x, $mc.y );//r2d.setCenterPoint( (rect.x + (rect.width + rect.x)) / 2, (rect.y + (rect.height + rect.y)) / 2 );
			return r2d;
		}
		
		
		static public function getDisplayObjectRect ( $do:DisplayObject ):Rectangle
		{
			return $do.getBounds( $do );
		}
		
		
		private function getCenterPoint ( $rect:Rectangle, $mc:MovieClip ):Point
		{
			var tmpRect:Rectangle;
			var p:Point = new Point();
			var currentFrame:int = $mc.currentFrame;
			var isPlay:Boolean = $mc.isPlaying;
			//
			$mc.gotoAndStop( 1 );
			tmpRect = $mc.getBounds( $mc );
			
			//
			if( isPlay )
			{
				$mc.gotoAndPlay( currentFrame );
			}
			else
			{
				$mc.gotoAndStop( currentFrame );
			}
			return p;
		}

		static public function getRangeByMovieClip ( $mc:MovieClip ):Rectangle
		{
			var tmpRect:Rectangle;
			var rect:Rectangle = new Rectangle( 999999999, 999999999, -999999999, -999999999 );
			var currentFrame:int = $mc.currentFrame;
			var isPlay:Boolean = $mc.isPlaying;
			for( var i:int = 1; i < $mc.totalFrames + 1; ++ i )
			{
				$mc.gotoAndStop( i );
				tmpRect = $mc.getBounds( $mc );
				tmpRect.width *= $mc.scaleX;
				tmpRect.height *= $mc.scaleY;
				tmpRect.width += tmpRect.x;
				tmpRect.height += tmpRect.y;
				if( rect.x > tmpRect.x )
				{
					rect.x = tmpRect.x;
				}
				if( rect.y > tmpRect.y )
				{
					rect.y = tmpRect.y;
				}
				if( rect.width < tmpRect.width )
				{
					rect.width = tmpRect.width;
				}
				if( rect.height < tmpRect.height )
				{
					rect.height = tmpRect.height;
				}
			}
			rect.width -= rect.x;
			rect.height -= rect.y;
			if( isPlay )
			{
				$mc.gotoAndPlay( currentFrame );
			}
			else
			{
				$mc.gotoAndStop( currentFrame );
			}
			return rect;
		}

		static public function getMaxHeight ( $mc:MovieClip ):Number
		{
			var mc:MovieClip = $mc;
			var isPlay:Boolean = $mc.isPlaying;
			var currentFrame:int = $mc.currentFrame;
			var result:Number = 0;
			for( var i:int = 0; i < $mc.totalFrames; ++ i )
			{
				$mc.gotoAndStop( i );
				if( $mc.height > result )
				{
					result = $mc.height;
				}
			}
			if( isPlay )
			{
				$mc.gotoAndPlay( currentFrame );
			}
			else
			{
				$mc.gotoAndStop( currentFrame );
			}
			return result;
		}
		
		static public function getMaxWidth ( $mc:MovieClip ):Number
		{
			var mc:MovieClip = $mc;
			var isPlay:Boolean = $mc.isPlaying;
			var currentFrame:int = $mc.currentFrame;
			var result:Number = 0;
			for( var i:int = 0; i < $mc.totalFrames; ++ i )
			{
				$mc.gotoAndStop( i );
				if( $mc.width > result )
				{
					result = $mc.width;
				}
			}
			if( isPlay )
			{
				$mc.gotoAndPlay( currentFrame );
			}
			else
			{
				$mc.gotoAndStop( currentFrame );
			}
			return result;
		}

	}
	
}
