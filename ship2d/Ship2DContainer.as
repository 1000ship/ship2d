package ship2d {
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display.Stage;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.text.TextField;
	import flash.geom.Vector3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Loader;
		
	public class Ship2DContainer {

		[Embed(source="logo.png", mimeType="application/octet-stream")] const LOGO:Class;

		
		private var logo:Loader;
		private var logoVisible:Boolean;
		
		private var i:int;
		public var stage:Stage;
		public var stage3d:Stage3D;
		public var context:Context3D;
		private var objects:Vector.<Rectangle2D>;
		private var program:Program3D;
		private var textureProgram:Program3D;
		private var agal:AGALMiniAssembler;
		private var agal2:AGALMiniAssembler;
		private var isCreate:Boolean;
		private var size:Point;
		private var transformSize:Point;
		private var matrix:Matrix3D;
		private var _antiAlias:int;
		private var bgc:Object = {r:0,g:0,b:0,a:1};
		public var positionBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var colorBuffer:VertexBuffer3D;
		
		//get Functions
		public function get screenSize ( ):Point
		{
			return size;
		}
		
		public function get antiAlias ():int
		{
			return _antiAlias;
		}
		
		public function get isContextCreate ():Boolean
		{
			return isCreate;
		}
		
		public function get numChildren():uint
		{
			return objects.length;
		}
		
		public function setBGC ( $r:Number = 0.0, $g:Number = 0.0, $b:Number = 0.0, $a:Number = 1.0 ):void
		{
			bgc.r = $r;
			bgc.g = $g;
			bgc.b = $b;
			bgc.a = $a;
		}

		public function Ship2DContainer ( $width:int, $height:int, $stage:Stage, $antiAlias:int = 4, $stageIndex:int = 0, $autoRequest:Boolean = true ) {
			// constructor code
			stage= $stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage3d = stage.stage3Ds[ $stageIndex ];
			agal = new AGALMiniAssembler();
			agal2 = new AGALMiniAssembler();
			matrix = new Matrix3D();
			size = new Point( $width, $height );
			transformSize = new Point( 1, 1 );
			_antiAlias = $antiAlias;
			objects = new Vector.<Rectangle2D>;
			//
			logo = new Loader();
			logoVisible = true;
			logo.loadBytes( new LOGO );
			stage.addChild( logo );
			//
			if( $autoRequest )
			{
				isCreate = false;
				stage3d.addEventListener(Event.CONTEXT3D_CREATE, c3dc );
				stage3d.requestContext3D();
			}
			else
			{
				isCreate = true;
				init();
			}
		}
		
		//c3dc
		private function c3dc ( e:Event ):void
		{
			isCreate = true;
			stage3d.removeEventListener(Event.CONTEXT3D_CREATE, c3dc );
			init();
		}
		private function init():void
		{
			context = stage3d.context3D;
			//context.enableErrorChecking = true; // Checking Error
			context.configureBackBuffer( size.x, size.y, _antiAlias, false );
			context.setCulling( Context3DTriangleFace.BACK );
			
			//context.setRenderToBackBuffer();
			context.setDepthTest(false, Context3DCompareMode.NEVER);
			context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA  );
			//context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE );
			//context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR );
			
			// normal program
			agal.assemble( Context3DProgramType.VERTEX, agalCode(
																	 'm44 op, va0, vc1',
																	 'mov v0, va1'));
			agal2.assemble( Context3DProgramType.FRAGMENT, agalCode(
																	'mov ft1, v0',
																	'mul ft1, ft1, fc0',
																	'mul ft1, ft1, fc1',
																	'mov oc, ft1'));
			program = context.createProgram();
			program.upload( agal.agalcode, agal2.agalcode );
			//
			textureProgram = context.createProgram();
			/*
			vc2.x size.x
			vc2.y size.y
			vc2.z width
			vc2.w height
			vc3.x scaleX
			vc3.y scaleY
			
			vc3.z valuex
			vc3.w valuey
			*/
			//matrix.appendScale( objects[ i ].width/size.x * objects[ i ].scaleX, objects[ i ].height/size.y * objects[ i ].scaleY, 1 );

			/*agal.assemble( Context3DProgramType.VERTEX, agalCode(
																 'mov vt0, va0',
																 'mov vt1, vc1',
																 // get scaleX
																// 'mul vt1.x, vt1.x, vc3.x',
																// 'div vt1.x, vt1.x, vc2.x',
																// 'mul vt1.x, vt1.x, vc2.z',
																 // get scaleY
																// 'mul vt1.y, vt1.y, vc3.y',
																// 'div vt1.y, vt1.y, vc2.y',
																// 'mul vt1.y, vt1.y, vc2.w',
																 // set scale
																 'mul vt0, vt0, vt1',
																 //
																 'm44 op, vt0, vc0',
																 'mov v0, va1'));*/
			
			// texture program
			agal.assemble( Context3DProgramType.VERTEX, agalCode(
																 'm44 vt0, va0, vc1',
																 
																// 'mov vt1, vc1',
																 //'div vt1, vt1, vc2',
																 //'mul vt1, vt1, vc3',
																 //'add vt1, vt1, vc4',
																 //'add vt0, vt0, vt1',
																 
																 'mov op, vt0',
																 'mov v0, va1'));
			agal2.assemble( Context3DProgramType.FRAGMENT, agalCode(
																	'mov ft0, v0',
																	'tex ft1, ft0, fs0 <2d, climp, linear>',
																	'mul ft1, ft1, fc0',
																	'mul ft1, ft1, fc1',
																	'mov oc, ft1'));
			textureProgram.upload( agal.agalcode, agal2.agalcode );
			createBuffer ();
			render();
		}
		
		// add, remove Object2D
		public function addObject2D ( obj:Object2D ):void
		{
			if( objects.indexOf( obj ) == -1 )
			{
				objects.push( obj );
			}
			else
			{
				trace( '추가된 객체입니다.' );
			}
		}
		
		public function removeObject2D ( obj:Object2D ):void
		{
			if( objects.indexOf( obj ) != -1 )
			{
				objects.splice( objects.indexOf( obj ), 1 );
			}
			else
			{
				trace( '없는 객체입니다.' );
			}
		}
		
		// agalCode
		private function agalCode ( ...str ):String
		{
			return str.join( '\n' );
		}
		
		//upload
		public function createBuffer ( ):void
		{
			positionBuffer = context.createVertexBuffer( 4, 3 );
			positionBuffer.uploadFromVector( Vector.<Number>([ -1, -1, 0, -1, 1, 0, 1, 1, 0, 1, -1, 0] ), 0, 4 );
			indexBuffer = context.createIndexBuffer( 6 );
			indexBuffer.uploadFromVector( Vector.<uint>( [ 0, 1, 2, 2, 3, 0 ] ), 0, 6 );
			uvBuffer = context.createVertexBuffer( 4, 2 );
			uvBuffer.uploadFromVector( Vector.<Number>( [ 0, 1, 0, 0, 1, 0, 1, 1 ] ), 0, 4 );
			colorBuffer = context.createVertexBuffer( 4, 4 );
			colorBuffer.uploadFromVector( Vector.<Number>( [ 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1 ] ), 0, 4 );
		}
		
		public function setNormalColorBuffer ( vec4x4:Vector.<Number> ):void
		{
			colorBuffer.uploadFromVector( vec4x4, 0, 4 );
		}
		
		public function render ( ):void
		{
			if( logoVisible )
			{
				if( stage.getChildIndex( logo ) < 0 )
				{
					stage.addChild( logo );
				}
				else
				{
					if( stage.getChildIndex( logo ) < stage.numChildren - 1 )
					{
						stage.setChildIndex( logo, stage.numChildren - 1 );
					}
				}
				logo.x = stage.stageWidth - logo.width;
				logo.y = stage.stageHeight - logo.height;
			}
			//
			if( isCreate )
			{
				//scale setting
				context.configureBackBuffer( stage.stageWidth, stage.stageHeight, _antiAlias, false );
				//stage3d.x = (size.x-stage.stageWidth) / 2;
				//stage3d.y = (size.y-stage.stageHeight) / 2;
				/*if( stage.stageWidth > stage.stageHeight )
				{
					transformSize.x = stage.stageHeight / stage.stageWidth;
					transformSize.y = 1;
				}
				else
				{
					transformSize.x = 1;
					transformSize.y = stage.stageWidth / stage.stageHeight;
				}*/
				//
				context.clear( bgc.r, bgc.g, bgc.b, bgc.a );
				for( i = 0; i < objects.length; i = i + 1 )
				{
					matrix.identity();
					matrix.appendScale( objects[ i ].width/size.x * objects[ i ].scaleX, objects[ i ].height/size.y * objects[ i ].scaleY, 1 );
					matrix.appendRotation( objects[ i ].rotation, Vector3D.Z_AXIS );
					matrix.appendScale( transformSize.x, transformSize.y, 1 );
					matrix.appendScale( size.x / stage.stageWidth, size.y / stage.stageHeight, 1 );
					matrix.appendTranslation( (objects[ i ].x - objects[i].centerPoint.x)/stage.stageWidth * 2 - 1, (objects[ i ].y - objects[i].centerPoint.y)/stage.stageHeight * -2 + 1, 0 );
					
					if( objects[ i ].hasTexture )
					{
						context.setProgram( textureProgram );
						context.setTextureAt( 0, objects[ i ].texture );
						context.setVertexBufferAt( 0, positionBuffer, 0, 'float3' );
						context.setVertexBufferAt( 1, uvBuffer, 0, 'float2' );
						context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, Vector.<Number>([ objects[i].colorTransform.redMultiplier, objects[i].colorTransform.greenMultiplier, objects[i].colorTransform.blueMultiplier, objects[i].colorTransform.alphaMultiplier ]) );
						context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 1, Vector.<Number>([ 1, 1, 1, objects[i].alpha ]) );
						
						/*context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 1, Vector.<Number>([ objects[i].x, objects[i].y, 0, 0 ]) );
						context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 2, Vector.<Number>([ stage.stageWidth, stage.stageHeight, 1, 1 ]) );
						context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 3, Vector.<Number>([ 2, -2, 1, 1 ]) );
						context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 4, Vector.<Number>([ -1, 1, 0, 0 ]) );
						*/
						
						if( objects[i].isAnimationTexture )
						{
							objects[i].changeFrame();
						}
					}
					else
					{
						//matrix.appendTranslation( (objects[ i ].x - objects[i].centerPoint.x)/stage.stageWidth * 2 - 1, (objects[ i ].y - objects[i].centerPoint.y)/stage.stageHeight * -2 + 1, 0 );
						context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, Vector.<Number>([ objects[i].colorTransform.redMultiplier, objects[i].colorTransform.greenMultiplier, objects[i].colorTransform.blueMultiplier, objects[i].colorTransform.alphaMultiplier ]) );
						context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 1, Vector.<Number>([ 1, 1, 1, objects[i].alpha ]) );
						
						context.setProgram( program );
						context.setVertexBufferAt( 0, positionBuffer, 0, 'float3' );
						context.setVertexBufferAt( 1, colorBuffer, 0, 'float4' );
					}
					//if( stage.stageWidth > 
					context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 1, matrix, true );
					context.drawTriangles( indexBuffer, 0, 2 );
				}
				context.present();
			}
		}

	}
	
}
