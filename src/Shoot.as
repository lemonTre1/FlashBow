package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	[SWF(backgroundColor="#009FFF",width="1024",height="768")]
	public class Shoot extends Sprite
	{
		private const  _totalWidth:Number=1024;
		private const  _totalHeight:Number=768;
		
		private var container:Sprite;
		private var circle:Sprite;

		
		private var delta:Number=1/30;
		private var positionDelta:Number=10;
		private var velocityDelta:Number=10;
		private var gravity:b2Vec2=new b2Vec2(0,10);
		private var world:b2World;
		
		
		public function Shoot()
		{
			createWorld();
			createDebug();
			stage.addEventListener(Event.ENTER_FRAME,loop);
			
		
			
			container = new Sprite();
			createCircle();
			container.addChild(circle);
			this.addChild(container);
			
			container.x = _totalWidth/2;
			container.y = 600;
			//container.rotation=-60;
			
			
			circle.addEventListener(MouseEvent.MOUSE_DOWN,moveCircle);
			circle.addEventListener(Event.ENTER_FRAME,drawLine);
			
			createStaticWalls(_totalWidth/2,_totalHeight,_totalWidth,10);
			createStaticWalls(_totalWidth/2,0,_totalWidth,10);
			createStaticWalls(0,_totalHeight/2,10,_totalHeight);
			createStaticWalls(_totalWidth,_totalHeight/2,10,_totalHeight);
		}
		
		

		
		/*
		 * start box2D*/
		
		private function createBody(posX:Number,posY:Number,velocity:b2Vec2):void{
			var bd:b2BodyDef=new b2BodyDef();
			bd.type=b2Body.b2_dynamicBody;
			bd.position=new b2Vec2(posX/30,posY/30);
	
			
			var cs:b2CircleShape=new b2CircleShape(10/30);
			
			var fd:b2FixtureDef=new b2FixtureDef();
		
			fd.shape=cs;
			
			var body:b2Body=world.CreateBody(bd);
			body.CreateFixture(fd);
			body.SetLinearVelocity(velocity);

		}
		
		
		private function createStaticWalls(posX:Number,posY:Number,width:Number,height:Number):void{
			var bd:b2BodyDef=new b2BodyDef();
			bd.type=b2Body.b2_staticBody;
			bd.position=new b2Vec2(posX/30,posY/30);
			
			
			var ps:b2PolygonShape=new b2PolygonShape();
			ps.SetAsBox(width/30,height/30);
			var fd:b2FixtureDef=new b2FixtureDef();
			
			fd.shape=ps;
			
			var body:b2Body=world.CreateBody(bd);
			body.CreateFixture(fd);	
		}
		
		
		private function loop(e:Event):void{
			world.Step(delta,velocityDelta,positionDelta);
			world.DrawDebugData();
		}
		
		private function createDebug():void{
			var debugSprite:Sprite=new Sprite();
			this.addChild(debugSprite);
			
			var debug:b2DebugDraw=new b2DebugDraw();
			debug.SetSprite(debugSprite);
			debug.SetDrawScale(30);
			debug.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			
			debug.SetFillAlpha(0.5);
			debug.SetLineThickness(1);
			
			world.SetDebugDraw(debug);
		}
		
		private function createWorld():void{
			var doSleep:Boolean=true;
			world=new b2World(gravity,doSleep);
		}
		
		/*
		 *end box2D*/
		private function moveCircle(e:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_UP,backCircle);
			var mc:Sprite = e.currentTarget as Sprite;
			circle.startDrag(false,new Rectangle(-100,0,200,200));
		}
		
		
		private function backCircle(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP,backCircle);
			circle.stopDrag();	
			var posX:Number=circle.x;
			var posY:Number=circle.y;
			circle.x=0;
			circle.y=0;
			
			var v:b2Vec2=new b2Vec2(50-posX,0-posY);
			var v1:b2Vec2=new b2Vec2(-50-posX,0-posY);
			v.Add(v1);
			v.Multiply(0.08);
			
			createBody(container.x,container.y,v);
			
		}
		
		
		private function createCircle():void{
			circle=new Sprite();
			circle.graphics.beginFill(0x4D9C62);
			circle.graphics.drawCircle(0,0,20);
			circle.graphics.endFill();
		}
		
		
		
		private function drawLine(e:Event):void{
			container.graphics.clear();
			container.graphics.lineStyle(10,0xFF0000,1);
			container.graphics.moveTo(circle.x,circle.y);
			container.graphics.lineTo(50,0);
			container.graphics.moveTo(circle.x,circle.y);
			container.graphics.lineTo(-50,0);
		}
	}
}