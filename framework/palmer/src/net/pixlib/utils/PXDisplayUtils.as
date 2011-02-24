/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.utils
{
	import net.pixlib.commands.PXCommandFPS;
	import net.pixlib.commands.PXDelegate;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXDebug;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;


	/**
	 * The PXDisplayUtils utility class is an all-static class with methods for 
	 * working with DislayObject objects.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 * @author Michael Barbero
	 */
	final public class PXDisplayUtils
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * Attaches <code>Sprite</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * <p>If <code>parent</code> is not <code>null</code>, Sprite is 
		 * automatically added into <code>parent</code> childs list.</p>
		 * 
		 * @param	linkage	ActionScript export identifier
		 * @param	parent	(optional) Created object's parent
		 * @param	domain	(optional) Domain where <code>linkage</code> is 
		 * 					defined.
		 * 
		 * @return new <code>Sprite</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 				
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function attachSprite(linkage : String, parent : DisplayObjectContainer = null, domain : ApplicationDomain = null) : Sprite
		{
			return _attachObject(linkage, parent, domain) as Sprite;
		}

		/**
		 * Creates new Sprite instance on passed-in parent container.
		 * 
		 * @param parent	Sprite container.
		 * 
		 * @return new Sprite instance on passed-in parent container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createSprite(parent : DisplayObjectContainer) : Sprite
		{
			return parent.addChild(new Sprite()) as Sprite;
		}

		/**
		 * Attaches <code>MovieClip</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * <p>If <code>parent</code> is not <code>null</code>, MovieClip is 
		 * automatically added into <code>parent</code> childs list.</p>
		 * 
		 * @param	linkage	ActionScript export identifier
		 * @param	parent	(optional) Created object's parent
		 * @param	domain	(optional) Domain where <code>linkage</code> is 
		 * 					defined.
		 * 
		 * @return new <code>MovieClip</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function attachMovieClip(linkage : String, parent : DisplayObjectContainer = null, domain : ApplicationDomain = null) : MovieClip
		{
			return _attachObject(linkage, parent, domain) as MovieClip;
		}

		/**
		 * Creates new MovieClip instance on passed-in parent container.
		 * 
		 * @param parent	Sprite container.
		 * 
		 * @return new MovieClip instance on passed-in parent container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createMovieClip(parent : DisplayObjectContainer) : MovieClip
		{
			return parent.addChild(new MovieClip()) as MovieClip;
		}

		/**
		 * Creates new TextField instance on passed-in parent container.
		 * 
		 * @param parent	Sprite container.
		 * 
		 * @return new TextField instance on passed-in parent container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createTextField(parent : DisplayObjectContainer) : TextField
		{
			return parent.addChild(new TextField()) as TextField;
		}

		/**
		 * Creates new Shape instance on passed-in parent container.
		 * 
		 * @param parent	Sprite container.
		 * 
		 * @return new Shape instance on passed-in parent container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createShape(parent : DisplayObjectContainer) : Shape
		{
			return parent.addChild(new Shape()) as Shape;
		}

		/**
		 * Retreives <code>BitmapData</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * @param	linkage	ActionScript image export identifier
		 * @param	domain	(optional) Domain where <code>linkage</code> is 
		 * 					defined.
		 * 
		 * @return new <code>BitmapData</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function attachBitmapData(linkage : String, domain : ApplicationDomain = null) : BitmapData
		{
			return _attachObject(linkage, null, domain) as BitmapData;
		}

		/**
		 * Attaches <code>Bitmap</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * <p>If <code>parent</code> is not <code>null</code>, Bitmap is 
		 * automatically added into <code>parent</code> childs list.</p>
		 * 
		 * @param	linkage	ActionScript image export identifier
		 * @param	parent	(optional) Created object's parent
		 * @param	domain	(optional) Domain where <code>linkage</code> is 
		 * 					defined.
		 * 
		 * @return new <code>Bitmap</code> object using passed-in 
		 * <code>linkage</code> ActionScript export identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function attachBitmap(linkage : String, parent : DisplayObjectContainer = null, domain : ApplicationDomain = null) : Bitmap
		{
			var data : BitmapData = attachBitmapData(linkage, domain);
			var instance : Bitmap = new Bitmap(data, PixelSnapping.AUTO, true);

			if ( parent != null )
			{
				return parent.addChild(instance) as Bitmap;
			}
			else return instance;
		}

		/**
		 * Creates new Bitmap instance on passed-in parent container and 
		 * BitmapData content.
		 * 
		 * <p>PixelSnapping is set to "AUTO" and smoothing to true.</p>
		 *  
		 * @param parent	Display container.
		 * @param data		BitmapData content
		 * 
		 * @return new Sprite instance on passed-in parent container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createBitmap(parent : DisplayObjectContainer, data : BitmapData = null) : Bitmap
		{
			return parent.addChild(new Bitmap(data, PixelSnapping.AUTO, true)) as Bitmap;
		}

		/**
		 * Adds passed-in Display Object list in parent container.
		 * 
		 * @param parent Display object container
		 * @param children	Childs to add to container
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function addChildren(parent : DisplayObjectContainer, children : Array) : void
		{
			var len : uint = children.length;
			for (var i : uint = 0; i < len; i++)
			{
				parent.addChild(children[i]);
			}
		}

		/**
		 * Applies button behaviour on passed-in target MovieClip
		 * 
		 * @param target	Sprite target.
		 * 
		 * @return button as MovieClip button type.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createMovieButton(target : Sprite) : MovieClip
		{
			try
			{
				return createButton(target) as MovieClip;
			}
			catch(e : Error)
			{
				PXDebug.ERROR("Not a button " + target, PXDisplayUtils);
			}
			return null;
		}

		/**
		 * Applies button behaviour on passed-in target Sprite
		 * 
		 * <p>Tab behaviour is turn off.</p>
		 * 
		 * @param target	Sprite target.
		 * 
		 * @return button as Sprite button type.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createButton(target : Sprite) : Sprite
		{
			target.buttonMode = true;
			target.mouseChildren = false;
			target.tabEnabled = false;
			target.tabChildren = false;

			return target;
		}

		/**
		 * Returns <code>container</code> child using passed-in <code>label</code> 
		 * child names chain.
		 * 
		 * @param 	container		Target container
		 * @param	label			Child names chain
		 * @param	throwException	(optional)<code>true</code> to throw 
		 * 							<code>PXNoSuchElementException</code> exception if
		 * 							child is not found. Either, only return <code>null</code> 
		 * 							without exception thrown.
		 * 							
		 * @return Container child or <code>null</code> if not find in container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function resolveUI(container : DisplayObject, label : String, throwException : Boolean = true) : DisplayObject
		{
			var target : DisplayObject = container;

			var arr : Array = label.split(".");
			var length : int = arr.length;

			for ( var i : int = 0;i < length;i++ )
			{
				var name : String = arr[ i ];
				if ( (target as DisplayObjectContainer).getChildByName(name) != null )
				{
					target = (target as DisplayObjectContainer).getChildByName(name);
				}
				else
				{
					if ( throwException )
					{
						throw new PXNoSuchElementException(".resolveUI(" + label + ") failed on " + container, PXDisplayUtils);
					}

					return null;
				}
			}

			return target;
		}

		/**
		 * Retrieves passed-in <code>label</code> named function in 
		 * <code>container</code> display object.
		 * 
		 * @param 	container		Target container
		 * @param	label			Function name to retreive
		 * @param	throwException	(optional)<code>true</code> to throw 
		 * 							<code>PXNoSuchElementException</code> exception if
		 * 							function is not found. Either, only return 
		 * 							<code>null</code> without exception thrown.
		 * 							
		 * @return Function or <code>null</code> if not find in container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function resolveFunction(container : DisplayObject, label : String, throwException : Boolean = true) : Function
		{
			var arr : Array = label.split(".");
			var func : String = arr.pop();
			var target : DisplayObjectContainer = resolveUI(container, arr.join("."), false) as DisplayObjectContainer ;

			if ( target.hasOwnProperty(func) && target[func] is Function  )
			{
				return target[func] ;
			}
			else
			{
				if ( throwException )
				{
					throw new PXNoSuchElementException(".resolveFunction(" + label + ") failed on " + container, PXDisplayUtils);
				}
			}

			return null;
		}

		/**
		 * Calls passed-in <code>callback</code> on all <code>target</code> 
		 * display tree child.
		 * 
		 * @param 	target			Displayobject target
		 * @param 	callback		Function to call on each tree child
		 * @param	processOwner	<code>true</code>(default) to call function 
		 * 							on <code>target</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function callOnDisplayTree(target : DisplayObject, callback : Function, processOwner : Boolean = true) : void
		{
			if ( processOwner ) callback(target);

			if ( target is DisplayObjectContainer )
			{
				var length : int = DisplayObjectContainer(target).numChildren;

				for (var i : uint = 0;i < length;i++)
				{
					callOnDisplayTree(DisplayObjectContainer(target).getChildAt(i), callback, true);
				}
			}
		}

		/**
		 * Returns tree path (in dot syntax) for passed-in display object.
		 * 
		 * @return tree path (in dot syntax) for passed-in display object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getTreePath(target : DisplayObject) : String
		{
			var result : String;

			try
			{
				for ( var o : DisplayObject = target;o != null;o = o.parent )
				{
					if (o.parent && o.stage && o.parent == o.stage) break;

					result = result == null ? o.name : o.name + "." + result;
				}
			}
			catch ( e : Error )
			{
			}

			return result;
		}

		/**
		 * Creates an unique name for passed-in object.
		 * 
		 * <p>Name is created using <code>PXHashCode.getKey()</code> 
		 * method and the type of passed-in object.</p>
		 * 
		 * @param object	Object requiring a name
		 * 
		 * @return String containing the object name 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createUniqueName(object : Object) : String
		{
			var key : String = PXHashCode.getKey(object);
			var name : String = getQualifiedClassName(object);
			var index : int = name.indexOf("::");
			if (index != -1) name = name.substr(index + 2);

			return name + "_" + key.substr(PXHashCode.PREFIX.length + 1);
		}

		/**
		 * Removes all childrens of passed-in <code>container</code>.
		 * 
		 * @param container	DisplayObjectContainer to clear.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function removeAllChildren(container : DisplayObjectContainer) : void
		{
			while ( container.numChildren > 0 ) container.removeChildAt(0);
		}

		/**
		 * Changes the rendering quality of application.
		 * 
		 * <p>The following are valid values:
		 * <ul>
		 * 	<li><code>StageQuality.LOW</code> — Low rendering quality. 
		 * 	Graphics are not anti-aliased, 
		 * 	and bitmaps are not smoothed. This setting is not supported in Adobe AIR.</li>
		 * 	<li><code>StageQuality.MEDIUM</code> — Medium rendering quality. 
		 * 	Graphics are anti-aliased 
		 * 	using a 2 x 2 pixel grid, but bitmaps are not smoothed. 
		 * 	This setting is suitable for movies that do not contain text. 
		 * 	This setting is not supported in Adobe AIR.</li>
		 * 	<li><code>StageQuality.HIGH</code> — High rendering quality. 
		 * 	Graphics are anti-aliased 
		 * 	using a 4 x 4 pixel grid, and bitmaps are smoothed if the movie is static. 
		 * 	This is the default rendering quality setting that Flash Player uses.</li>
		 * 	<li><code>StageQuality.BEST</code> — Very high rendering quality. 
		 * 	Graphics are anti-aliased using a 4 x 4 pixel grid and bitmaps 
		 * 	are always smoothed.</li>
		 * </ul></p>
		 * 
		 * @param	stage	Main Stage
		 * @param	quality	New rendering quality to use
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function changeQuality(stage : Stage, quality : String = "best") : void
		{
			if ((stage != null) && (stage.quality != quality))
			{
				try
				{
					stage.quality = quality;
				}
				catch( e : Error )
				{
					PXDebug.ERROR("Stage quality change failed = " + e.message, PXDisplayUtils);
				}
			}
		}

		/**
		 * Changes the frame rate of the stage. 
		 * 
		 * <p>The frame rate is defined as frames per second. 
		 * By default the rate is set to the frame rate of the first SWF file loaded. 
		 * Valid range for the frame rate is from 0.01 to 1000 frames per second.</p>
		 * 
		 * @param	stage		Main Stage
		 * @param	framerate	New frame rate to use
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function changeFramerate(stage : Stage, framerate : uint = 31) : void
		{
			if ((stage != null) && (stage.frameRate != framerate))
			{
				if (framerate <= 1000)
				{
					try
					{
						stage.frameRate = framerate;
					}
					catch(e : Error)
					{
						PXDebug.ERROR("Stage framerate change failed = " + e.message, PXDisplayUtils);
					}
				}
			}
		}

		/**
		 * Set passed-in <code>layer</code> in top position (in depth) on his 
		 * parent container.
		 * 
		 * @param	layer	Layer to set to top layer in parent container.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function toTop(layer : DisplayObject) : void
		{
			try
			{
				var parent : DisplayObjectContainer = layer.parent as DisplayObjectContainer;
				if (parent.numChildren > 0) parent.setChildIndex(layer, parent.numChildren - 1);
			}
			catch(e : Error)
			{
				PXDebug.ERROR("Can't push '" + layer + "' on top." + e.message, PXDisplayUtils);
			}
		}

		/**
		 * Translates and returns passed-in point using coordinates transformation.
		 * 
		 * @param target	Point to translate
		 * @param fromCoordinates	Source coordinates space
		 * @param toCoordinates		Target coordinates space
		 * 
		 * @return translated passed-in point using coordinates transformation.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function translatePoint(target : Point, fromCoordinates : DisplayObject, toCoordinates : DisplayObject) : Point
		{
			var translated : Point;
			translated = target.clone();
			translated = fromCoordinates.localToGlobal(translated);
			translated = toCoordinates.globalToLocal(translated);
			return translated;
		}

		/**
		 * Takes a snapshot of passed-in display object.
		 * 
		 * @param target	The display object to take
		 * @param useColor	(optional) retreive color transformation of target object
		 * 
		 * @return a BitmapData representing a snapshot of passed-in display 
		 * 			object
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getSnapshot(target : DisplayObject, useColor : Boolean = false) : BitmapData
		{
			var mat : Matrix = _getMatrix(target);
			var bounds : Rectangle = _getRealBounds(target, mat);

			if (bounds.width == 0 || bounds.height == 0) return null;
			if (mat) mat.translate(-(Math.floor(bounds.x)), -(Math.floor(bounds.y)));

			var data : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0);
			data.draw(target, mat, useColor ? target.transform.colorTransform : null);

			return data;
		}

		/**
		 * Replaces passed-in target with his snapshot represenation.
		 * 
		 * @param target	The display object to take
		 * @param useColor	(optional) retreive color transformation of target object
		 * 
		 * @return The created Bitmap instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function replaceSnapShot(target : DisplayObject, useColor : Boolean = true) : Bitmap
		{
			var data : BitmapData = getSnapshot(target, useColor);
			var bmp : Bitmap = new Bitmap(data, PixelSnapping.AUTO, true);
			bmp.x = target.x;
			bmp.y = target.y;

			if (target.parent)
			{
				var parent : DisplayObjectContainer = target.parent;
				var index : uint = target.parent.getChildIndex(target);

				parent.addChildAt(bmp, index);
				parent.removeChild(target);
			}

			return bmp;
		}

		/**
		 * Sets the focus to passed-in interactive object.
		 * 
		 * @param target	The interactive  object to focus
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function setFocus(target : InteractiveObject) : void
		{
			if (target && target.stage)
			{
				PXCommandFPS.getInstance().delay(new PXDelegate(_activeFocus, target));
			}
		}
		
		/**
		 * Returns the hightest available depth for passed-in container.
		 * 
		 * @param container	The container to search in
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getHighestDepth(container : DisplayObjectContainer) : int
		{
			if ( container == null ) return -1;
			else return Math.max(0, container.numChildren - 1);
		}
		

		// --------------------------------------------------------------------
		// Private implementation
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function _activeFocus(target : InteractiveObject) : void
		{
			target.stage.focus = target;
		}

		/** @private */
		private static function _attachObject(linkage : String, parent : DisplayObjectContainer = null, domain : ApplicationDomain = null) : *
		{
			try
			{
				var clazz : Class = domain ? domain.getDefinition(linkage) as Class : getDefinitionByName(linkage) as Class;

				var instance : * = new clazz();

				if ( parent != null )
				{
					return parent.addChild(instance);
				}
				else return instance;
			}
			catch( e : ReferenceError )
			{
				PXDebug.ERROR(e.message, PXDisplayUtils);
			}

			return null;
		}

		/**
		 * @private
		 */
		private static function _getRealBounds(targ : DisplayObject, m : Matrix = null, padding : int = 10) : Rectangle
		{
			var bitmap : BitmapData = new BitmapData(targ.width + 2 * padding, targ.height + 2 * padding, true, 0x00000000);
			if (!m)
				m = new Matrix();
			var tx : Number = m.tx;
			var ty : Number = m.ty;
			m.translate(-tx + padding, -ty + padding);
			var tmpOpaqueBackground : Object = targ.opaqueBackground;
			targ.opaqueBackground = 0xFFFFFFFF;
			bitmap.draw(targ, m);
			m.translate(tx - padding, ty - padding);
			targ.opaqueBackground = tmpOpaqueBackground;
			var actualBounds : Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x0, false);
			if ((actualBounds.width == 0 || actualBounds.height == 0) || (actualBounds.x > 0 && actualBounds.y > 0 && actualBounds.right < bitmap.width && actualBounds.bottom < bitmap.height))
			{
				actualBounds.x = actualBounds.x + tx - padding;
				actualBounds.y = actualBounds.y + ty - padding;
				bitmap.dispose();
				return actualBounds;
			}
			else
			{
				var newPadding : int = (padding == 0) ? 10 : 2 * padding;

				bitmap.dispose();
				return _getRealBounds(targ, m, newPadding);
			}
		}

		private static function _getMatrix(displayObject : DisplayObject) : Matrix
		{
			var m : Matrix = new Matrix();

			while (displayObject && displayObject.transform.matrix)
			{
				var scrollRect : Rectangle = displayObject.scrollRect;
				if (scrollRect != null)
					m.translate(-scrollRect.x, -scrollRect.y);

				m.concat(displayObject.transform.matrix);

				displayObject = displayObject.parent as DisplayObject;
			}
			return m;
		}

		/** @private */
		function PXDisplayUtils()
		{
		}
	}
}
