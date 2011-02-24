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
package net.pixlib.load
{
	import net.pixlib.load.strategy.PXLoaderStrategy;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	/**
	 * The PXGraphicLoader class is used to load SWF files or image (JPG, PNG, 
	 * or GIF) files. 
	 * 
	 * @example
	 * <listing>
	 * 
	 * var loader : PXGraphicLoader = new PXGraphicLoader( mcContainer, -1, true );
	 * loader.load( new URLRequest( "logo.swf" );
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 * @author Francis Bourre
	 * @author Michael Barbero
	 */
	public class PXGraphicLoader extends PXAbstractLoader
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _target : DisplayObjectContainer;
		/**
		 * @private
		 */
		private var _index : int;
		/**
		 * @private
		 */
		private var _bAutoShow : Boolean;
		/**
		 * @private
		 */
		private var _oBitmapContainer : Sprite;

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**
		 * Returns the container of loaded object.
		 * 
		 * @return The container of loaded object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get target() : DisplayObjectContainer
		{
			return _target;
		}

		/**
		 * @private
		 */
		public function set target(target : DisplayObjectContainer) : void
		{
			_target = target ;

			if ( _target != null )
			{
				if ( _index != -1 )
				{
					_target.addChildAt(displayObject, _index);
				}
				else
				{
					_target.addChild(displayObject);
				}
			}
		}

		/**
		 * Display object visible state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get visible() : Boolean
		{
			return displayObject.visible;
		}

		/**
		 * @private
		 */
		public function set visible(value : Boolean) : void
		{
			displayObject.visible = value;
		}

		/**
		 * Indicates if loaded graphic must be display when loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get autoShow() : Boolean
		{
			return _bAutoShow;
		}

		/**
		 * @private
		 */
		public function set autoShow(value : Boolean) : void
		{
			_bAutoShow = value;
		}

		/**
		 * Sets the index of loaded display object in 
		 * target display list.
		 * 
		 * @param	index		Index of loaded display object in target 
		 * 						display list
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set index(index : int) : void
		{
			_index = index;

			if ( _target != null )
			{
				_target.addChildAt(displayObject, _index);
			}
		}

		/**
		 * Shows the display object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function show() : void
		{
			displayObject.visible = true;
		}

		/**
		 * Defines the new content ( display object ) of the loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function set content(value : Object) : void
		{
			if ( value is Bitmap )
			{
				Bitmap(value).smoothing = true;

				_oBitmapContainer = new Sprite();
				_oBitmapContainer.addChild(value as Bitmap);
			}
			else
			{
				_oBitmapContainer = null;
			}

			super.content = value;

			if ( name != null )
			{
				try
				{
					displayObject.name = name;
				}
				catch( e : Error )
				{
					// timeline based object
				}
			}
		}

		/**
		 * Returns the display object.
		 * 
		 * @return The display object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get displayObject() : DisplayObjectContainer
		{
			return _oBitmapContainer ? _oBitmapContainer : super.content as DisplayObjectContainer;
		}

		/**
		 * Returns the raw content.
		 * 
		 * @return The raw content.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get rawContent() : *
		{
			return super.content;
		}

		/**
		 * @inheritDoc
		 */
		override public function get content() : Object
		{
			return displayObject;
		}

		/**
		 * Returns a LoaderInfo object corresponding to the object being loaded.
		 * 
		 * @return A LoaderInfo object corresponding to the object being loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get contentLoaderInfo() : LoaderInfo
		{
			return PXLoaderStrategy(strategy).contentLoaderInfo;
		}

		/**
		 * Returns the <code>applicationDomain</code> of loaded display object.
		 * 
		 * @return The <code>applicationDomain</code> of loaded display object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get contentApplicationDomain() : ApplicationDomain
		{
			return ( strategy as PXLoaderStrategy ).contentLoaderInfo.applicationDomain;
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * Creates new instance.
		 * 
		 * @param	target		(optional) Container of loaded display object
		 * @param	index		(optional) Index of loaded display object in target 
		 * 						display list
		 * @param	autoShow	(optional) Loaded object visibility
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXGraphicLoader(target : DisplayObjectContainer = null, index : int = -1, autoShow : Boolean = true)
		{
			super(new PXLoaderStrategy());

			_target = target;
			_index = index;
			_bAutoShow = autoShow;
		}

		/**
		 * @inheritDoc
		 */
		override protected function onInitialize() : void
		{
			if ( _target ) target = _target;

			if ( _bAutoShow )
			{
				show();
			}
			else
			{
				hide();
			}

			super.onInitialize();
		}

		/**
		 * Hides the display object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hide() : void
		{
			displayObject.visible = false;
		}

		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			if ( content && _target && _target.contains(displayObject) ) _target.removeChild(displayObject);

			super.release();
		}
	}
}