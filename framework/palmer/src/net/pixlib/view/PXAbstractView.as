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
package net.pixlib.view
{
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.model.PXModelEvent;
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginDebug;
	import net.pixlib.structures.PXDimension;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;


	/**
	 * Dispatched when view is initialized.
	 *  
	 * @eventType net.pixlib.view.PXViewEvent.onInitViewEVENT
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onInitView", type="net.pixlib.view.PXViewEvent")]
	/**
	 * Dispatched when view is released.
	 *  
	 * @eventType net.pixlib.view.PXViewEvent.onReleaseViewEVENT
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onReleaseView", type="net.pixlib.view.PXViewEvent")]
	/**
	 * The PXAbstractView class is an abstract implementation of View 
	 * part of the Pixlib MVC implementation.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	public class PXAbstractView implements PXView
	{
		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		/** 
		 * Instance identifier in <code>PXViewLocator</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var sName : String;

		/** 
		 * EventBroadcaster for this instance. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oEB : PXEventBroadcaster;

		/** 
		 * Plugin owner of this view. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oOwner : PXPlugin;

		/**
		 * Event used in all view broadcasted event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var event : PXViewEvent;

		/**  
		 * DisplayObject controlled by this view instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var content : DisplayObject;

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		public function get owner() : PXPlugin
		{
			return oOwner;
		}

		/**
		 * @private
		 */
		public function set owner(value : PXPlugin) : void
		{
			oOwner = value ? value : PXBasePlugin.getInstance();
		}

		/**
		 * Returns view Log instance used by this view.
		 * 
		 * @return view Log instance used by this view.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get logger() : PXPluginDebug
		{
			return PXPluginDebug.getInstance(owner);
		}

		/**
		 * Content visibility state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get visible() : Boolean
		{
			return content.visible;
		}

		/**
		 * @private
		 */
		public function set visible(value : Boolean) : void
		{
			if (value) show();
			else hide();
		}

		/**
		 * @inheritDoc
		 */
		public function get position() : Point
		{
			return new Point(content.x, content.y);
		}

		/**
		 * @private
		 */
		public function set position(value : Point) : void
		{
			content.x = value.x;
			content.y = value.y;
		}

		/**
		 * @inheritDoc
		 */
		public function get size() : PXDimension
		{
			return new PXDimension(content.width, content.height);
		}

		/**
		 * @private
		 */
		public function set size(value : PXDimension) : void
		{
			content.width = value.width;
			content.height = value.height;
		}

		/**
		 * @inheritDoc
		 */
		public function get name() : String
		{
			return sName;
		}

		/**
		 * @private
		 */
		public function set name(value : String) : void
		{
			var locator : PXViewLocator = PXViewLocator.getInstance(owner);

			if (value != null && ( !(locator.isRegistered(value)) || value == name ) )
			{
				if ( value != null && locator.isRegistered(value) ) locator.unregister(value);
				if ( locator.register(value, this) ) sName = value;

				event.value = sName;
			}
			else
			{
				throw new PXIllegalArgumentException("set name failed. '" + value + "' is already registered in ViewLocator.", this);
			}
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * @private
		 */
		public function handleEvent(event : Event) : void
		{
			//
		}

		/**
		 * @inheritDoc
		 */
		public function notifyChanged(event : Event) : void
		{
			oEB.broadcastEvent(event);
		}

		/**
		 * Registers passed-in <code>dpo</code> display object as 
		 * controlled display object by this view instance.
		 * 
		 * @param	dpo		DisplayObject to control in this view
		 * @param	name	View's identifier
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function registerView(dpo : DisplayObject, viewName : String = null) : void
		{
			_initAbstractView(name, dpo, (( viewName && (viewName != name) ) ? viewName : null));
		}

		/**
		 * @inheritDoc
		 */
		public function show() : void
		{
			content.visible = true;
		}

		/**
		 * @inheritDoc
		 */
		public function hide() : void
		{
			content.visible = false;
		}

		/**
		 * Moves content using passed-in coordinates.
		 * 
		 * @param	x	X coordinate		 * @param	y	Y coordinate
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function move(x : Number, y : Number) : void
		{
			position = new Point(x, y);
		}

		/**
		 * Sets new content size using passed-in size arguments.
		 * 
		 * @param	w	New content width		 * @param	h	New content height
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setSizeWH(w : Number, h : Number) : void
		{
			size = new PXDimension(w, h);
		}

		/**
		 * Returns <code>true</code> if Display object in passed-in tree path 
		 * can be located in view content display tree.
		 * 
		 * @param	label	Name or tree path for object to search
		 * 
		 * @return <code>true</code> if Display object in passed-in tree path 
		 * can be located in view content display tree.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function canResolveUI(label : String) : Boolean
		{
			try
			{
				return resolveUI(label, true) is DisplayObject;
			}
			catch ( e : Error )
			{
				return false;
			}

			return false;
		}

		/**
		 * Returns DisplayObject instance in current view's content.
		 * 
		 * @param label	full qualified path (dot syntax) to targeted display object
		 * @param tryToResolve	(optional) <code>true</code> to thrown execption 
		 * 						if display object does not exist; either return 
		 * 						<code>null</code>
		 * @return 	The DisplayObject instance in current view's content or 
		 * 			<code>null</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function resolveUI(label : String, tryToResolve : Boolean = false) : DisplayObject
		{
			return resolveUIImp(content, label, tryToResolve);
		}

		/**
		 * @private
		 */
		protected function resolveUIImp(target : DisplayObject, label : String, tryToResolve : Boolean = false) : DisplayObject
		{
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
					if ( tryToResolve )
					{
						throw new PXNoSuchElementException(".resolveUI(" + label + ") failed on " + target, this);
					}

					return null;
				}
			}

			return target;
		}

		/**
		 * Returns <code>true</code> if Function in passed-in tree path 
		 * can be located in view content display tree.
		 * 
		 * @param	label	Name or tree path for function to search
		 * 
		 * @return <code>true</code> if Function in passed-in tree path 
		 * can be located in view content display tree.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function canResolveFunction(label : String) : Boolean
		{
			try
			{
				return resolveFunction(label, true) is Function;
			}
			catch ( e : Error )
			{
				return false;
			}

			return false;
		}

		/**
		 * Returns Function defined in current view's content.
		 * 
		 * @param label	full qualified path (dot syntax) to targeted function
		 * @param tryToResolve	(optional) <code>true</code> to thrown execption 
		 * 						if display object does not exist; either return 
		 * 						<code>null</code>
		 * 						
		 * @return The Function is defined in current view's content.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function resolveFunction(label : String, tryToResolve : Boolean = false) : Function
		{
			var arr : Array = label.split(".");
			var func : String = arr.pop();
			var target : DisplayObjectContainer = resolveUI(arr.join("."), false) as DisplayObjectContainer ;

			if ( target.hasOwnProperty(func) && target[func] is Function  )
			{
				return target[func] ;
			}
			else
			{
				if ( tryToResolve )
				{
					throw new PXNoSuchElementException(".resolveFunction(" + label + ") failed on " + target, this);
				}
			}

			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			PXViewLocator.getInstance(owner).unregister(name);

			if ( content != null )
			{
				if ( content.parent != null ) content.parent.removeChild(content);
				content = null;
			}

			onReleaseView();

			oEB.removeAllListeners();
			oEB = null;
			sName = null;
		}

		/**
		 * @inheritDoc
		 */
		final public function addListener(listener : PXViewListener) : Boolean
		{
			return oEB.addListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function hasListener(type : PXViewListener) : Boolean
		{
			return oEB.isRegistered(type);
		}

		/**
		 * @inheritDoc
		 */
		public function hasListenerCollectionType(type : String) : Boolean
		{
			return oEB.hasListenerCollection(type);
		}

		/**
		 * @inheritDoc
		 */
		final public function removeListener(listener : PXViewListener) : Boolean
		{
			return oEB.removeListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		final public function addEventListener(type : String, listener : Object, ... rest) : Boolean
		{
			return oEB.addEventListener.apply(oEB, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**
		 * @inheritDoc
		 */
		final public function removeEventListener(type : String, listener : Object) : Boolean
		{
			return oEB.removeEventListener(type, listener);
		}

		/**
		 * @inheritDoc
		 */
		public function onInitModel(event : PXModelEvent) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onReleaseModel(event : PXModelEvent) : void
		{
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * Broadcasts <code>onInitView</code> event to listeners.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onInitView() : void
		{
			event.type = PXViewEvent.onInitViewEVENT;
			notifyChanged(event);
		}

		/**
		 * Broadcasts <code>onReleaseView</code> event to listeners.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onReleaseView() : void
		{
			event.type = PXViewEvent.onReleaseViewEVENT;
			notifyChanged(event);
		}

		/**
		 * Fires passed-in <code>event</code> in private communication 
		 * channel.
		 * 
		 * <p>Private communication channel is used in MVC architecture.</p>
		 * 
		 * @param event	Event to broadcast.
		 * 
		 * @see net.pixlib.commands.PXFrontController
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function firePrivateEvent(event : Event) : void
		{
			owner.firePrivateEvent(event);
		}

		/**
		 * Fires passed-in <code>event</code> in public communication 
		 * channel.
		 * 
		 * <p>Public communication channel is used in Plugin architecture.</p>
		 * 
		 * @param event	Event to broadcast.
		 * 
		 * @see net.pixlib.commands.PXFrontController
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function firePublicEvent(event : Event) : void
		{
			owner.firePublicEvent(event);
		}

		/**
		 * Fires passed-in <code>event</code> in external communication 
		 * using dedicated channel.
		 * 
		 * <p>External communication channel is used in Plugin architecture.</p>
		 * 
		 * @param event	Event to broadcast.
		 * 
		 * @see net.pixlib.commands.PXFrontController
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireExternalEvent(event : Event, channel : PXEventChannel) : void
		{
			owner.fireExternalEvent(event, channel);
		}

		// --------------------------------------------------------------------
		// Private implementation
		// --------------------------------------------------------------------
		/**
		 * Creates new instance.
		 * 
		 * @param	owner	(optional) Plugins owner.
		 * @param	name	(optional) View's identifier.
		 * @param	dpo		(optional) DisplayObject to control in this view.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXAbstractView(viewOwner : PXPlugin = null, viewName : String = null, dpo : DisplayObject = null)
		{
			oEB = new PXEventBroadcaster(this);
			event = new PXViewEvent(PXViewEvent.onInitViewEVENT, this, "");
			owner = viewOwner;
			
			if (viewName != null) _initAbstractView(viewName, dpo, null);
		}

		/**
		 * @private
		 */
		private function _initAbstractView(viewName : String, dpo : DisplayObject, avName : String) : void
		{
			if ( dpo != null )
			{
				this.content = dpo;
			}
			else if ( ( PXCoreFactory.getInstance().isRegistered(viewName) && PXCoreFactory.getInstance().locate(viewName) is DisplayObject ) )
			{
				this.content = ( PXCoreFactory.getInstance().locate(viewName) as DisplayObject );
			}

			name = avName ? avName : viewName;
			onInitView();
		}
	}
}