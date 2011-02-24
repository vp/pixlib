/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */package net.pixlib.view{	import net.pixlib.plugin.PXPlugin;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.MovieClip;	import flash.display.Shape;	import flash.display.Sprite;	import flash.display.Stage;	import flash.text.TextField;		/**	 * The PXContainerView view implements default View behaviour to 	 * use DisplayObjectContainer as content.	 * 	 * 	 * @example	 * <listing>	 * package	 * {	 * 	public class MyToolbar extends PXContainerView	 * 	{	 * 		public function MyToolbar(owner : PXPlugin = null)	 * 		{	 * 			super(owner, "MyToolbar");	 * 		}	 * 			 * 		override protected function onInitView() : void	 * 		{	 * 			var button : Sprite = addSprite();	 * 				 * 			super.onInitView();	 * 		}	 * 	}	 * 		 * }	 * </listing>	 * 	 * @langversion 3.0	 * @playerversion Flash 10 	 *	 * @author Romain Ecarnot	 */
	public class PXContainerView extends PXAbstractView
	{		// --------------------------------------------------------------------		// Protected properties		// --------------------------------------------------------------------				/**		 * The container instance of current view.		 * 		 * @return The container instance of current view.		 *		 * @langversion 3.0		 * @playerversion Flash 10		 */		protected function get container() : DisplayObjectContainer		{			return content as DisplayObjectContainer;		}				/**		 * Returns application stage.		 * 		 * @return application stage.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		protected function get stage() : Stage		{			return content.stage;		}				
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**		 * Creates instance.		 * 		 * @param name	View's identifier (must be unique in application)		 * @param dpo	View's container		 * 				<p>You can use PXLayerManager class to manage predefined 		 * 				display object level.</p>		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function PXContainerView(viewOwner : PXPlugin = null, viewName : String = null, dpo : DisplayObject = null)
		{
			super(viewOwner, viewName, dpo);
		}		

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------				/**		 * Triggered when view is ready to be used.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		override protected function onInitView() : void		{			initBehaviour();						super.onInitView();
		}				/**
		 * Inits default view behaviours.		 * 		 * <p>Sets the tabEnabled and tabChildren  to false.</p>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function initBehaviour() : void
		{
			container.tabEnabled = false;			container.tabChildren  = false;
		}				/**		 * Adds passed-in DisplayObject in content display list.		 * 		 * @param child	DisplayObject to add in content display list.		 * 		 * @return added display object		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		final protected function addChild(child : DisplayObject) : DisplayObject
		{
			return container.addChild(child);
		}
		
		/**		 * Adds passed-in DisplayObject in content display list at passed-in 		 * index position.		 * 		 * @param child	DisplayObject to add in content display list.		 * @param index	Displayobject position in display list.		 * 		 * @return added display object		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		final protected function addChildAt(child : DisplayObject, index : int) : DisplayObject
		{
			return container.addChildAt(child, index);
		}

		/**		 * Removes passed-in child object from content display list.		 * 		 * @param child	DisplayObject to remove from content display list.		 * 		 * @return removed display object		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		final protected function removeChild(child : DisplayObject) : DisplayObject
		{
			return container.removeChild(child);
		}

		/**		 * Removes DisplayObject from content display list at passed-in 		 * index position.		 * 		 * @param index	Displayobject position in display list.		 * 		 * @return removed display object		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		final protected function removeChildAt(index : int) : DisplayObject
		{
			return container.removeChildAt(index);
		}				/**		 * Clears all container childs.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		final protected function removeChildren() : void		{			while( container.numChildren > 0 ) container.removeChildAt(0);
		}				/**		 * Shortcut to create an return TextField instance.		 * 		 * @return new TextField instance created on view container display list.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		final protected function addTextField() : TextField		{			return addChild(new TextField()) as TextField;		}				/**		 * Shortcut to create an return Sprite instance.		 * 		 * @return new Sprite instance created on view container display list.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		final protected function addSprite() : Sprite		{			return addChild(new Sprite()) as Sprite;		}				/**		 * Shortcut to create an return MovieClip instance.		 * 		 * @return new MovieClip instance created on view container display list.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		final protected function addMovieClip() : MovieClip		{			return addChild(new MovieClip()) as MovieClip;		}				/**		 * Shortcut to create an return Shape instance.		 * 		 * @return new Shape instance created on view container display list.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		final protected function addShape() : Shape		{			return addChild(new Shape()) as Shape;		}				/**		 * Shortcut to create an return Bitmap instance.		 * 		 * @return new Bitmap instance created on view container display list.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		final protected function addBitmap(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false) : Bitmap
		{
			return addChild(new Bitmap(bitmapData, pixelSnapping, smoothing)) as Bitmap;		}	}
}