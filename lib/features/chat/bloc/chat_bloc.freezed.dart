// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent()';
}


}

/// @nodoc
class $ChatEventCopyWith<$Res>  {
$ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatStarted value)?  started,TResult Function( ChatMessageSent value)?  messageSent,TResult Function( ChatMarkedAsRead value)?  markedAsRead,TResult Function( ChatMessagesReceived value)?  messagesReceived,TResult Function( ChatStreamError value)?  streamError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started(_that);case ChatMessageSent() when messageSent != null:
return messageSent(_that);case ChatMarkedAsRead() when markedAsRead != null:
return markedAsRead(_that);case ChatMessagesReceived() when messagesReceived != null:
return messagesReceived(_that);case ChatStreamError() when streamError != null:
return streamError(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatStarted value)  started,required TResult Function( ChatMessageSent value)  messageSent,required TResult Function( ChatMarkedAsRead value)  markedAsRead,required TResult Function( ChatMessagesReceived value)  messagesReceived,required TResult Function( ChatStreamError value)  streamError,}){
final _that = this;
switch (_that) {
case ChatStarted():
return started(_that);case ChatMessageSent():
return messageSent(_that);case ChatMarkedAsRead():
return markedAsRead(_that);case ChatMessagesReceived():
return messagesReceived(_that);case ChatStreamError():
return streamError(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatStarted value)?  started,TResult? Function( ChatMessageSent value)?  messageSent,TResult? Function( ChatMarkedAsRead value)?  markedAsRead,TResult? Function( ChatMessagesReceived value)?  messagesReceived,TResult? Function( ChatStreamError value)?  streamError,}){
final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started(_that);case ChatMessageSent() when messageSent != null:
return messageSent(_that);case ChatMarkedAsRead() when markedAsRead != null:
return markedAsRead(_that);case ChatMessagesReceived() when messagesReceived != null:
return messagesReceived(_that);case ChatStreamError() when streamError != null:
return streamError(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String matchId)?  started,TResult Function( String text)?  messageSent,TResult Function()?  markedAsRead,TResult Function( List<ChatMessage> messages)?  messagesReceived,TResult Function( String message)?  streamError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started(_that.matchId);case ChatMessageSent() when messageSent != null:
return messageSent(_that.text);case ChatMarkedAsRead() when markedAsRead != null:
return markedAsRead();case ChatMessagesReceived() when messagesReceived != null:
return messagesReceived(_that.messages);case ChatStreamError() when streamError != null:
return streamError(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String matchId)  started,required TResult Function( String text)  messageSent,required TResult Function()  markedAsRead,required TResult Function( List<ChatMessage> messages)  messagesReceived,required TResult Function( String message)  streamError,}) {final _that = this;
switch (_that) {
case ChatStarted():
return started(_that.matchId);case ChatMessageSent():
return messageSent(_that.text);case ChatMarkedAsRead():
return markedAsRead();case ChatMessagesReceived():
return messagesReceived(_that.messages);case ChatStreamError():
return streamError(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String matchId)?  started,TResult? Function( String text)?  messageSent,TResult? Function()?  markedAsRead,TResult? Function( List<ChatMessage> messages)?  messagesReceived,TResult? Function( String message)?  streamError,}) {final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started(_that.matchId);case ChatMessageSent() when messageSent != null:
return messageSent(_that.text);case ChatMarkedAsRead() when markedAsRead != null:
return markedAsRead();case ChatMessagesReceived() when messagesReceived != null:
return messagesReceived(_that.messages);case ChatStreamError() when streamError != null:
return streamError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChatStarted implements ChatEvent {
  const ChatStarted(this.matchId);
  

 final  String matchId;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStartedCopyWith<ChatStarted> get copyWith => _$ChatStartedCopyWithImpl<ChatStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStarted&&(identical(other.matchId, matchId) || other.matchId == matchId));
}


@override
int get hashCode => Object.hash(runtimeType,matchId);

@override
String toString() {
  return 'ChatEvent.started(matchId: $matchId)';
}


}

/// @nodoc
abstract mixin class $ChatStartedCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatStartedCopyWith(ChatStarted value, $Res Function(ChatStarted) _then) = _$ChatStartedCopyWithImpl;
@useResult
$Res call({
 String matchId
});




}
/// @nodoc
class _$ChatStartedCopyWithImpl<$Res>
    implements $ChatStartedCopyWith<$Res> {
  _$ChatStartedCopyWithImpl(this._self, this._then);

  final ChatStarted _self;
  final $Res Function(ChatStarted) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchId = null,}) {
  return _then(ChatStarted(
null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatMessageSent implements ChatEvent {
  const ChatMessageSent(this.text);
  

 final  String text;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageSentCopyWith<ChatMessageSent> get copyWith => _$ChatMessageSentCopyWithImpl<ChatMessageSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageSent&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'ChatEvent.messageSent(text: $text)';
}


}

/// @nodoc
abstract mixin class $ChatMessageSentCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatMessageSentCopyWith(ChatMessageSent value, $Res Function(ChatMessageSent) _then) = _$ChatMessageSentCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$ChatMessageSentCopyWithImpl<$Res>
    implements $ChatMessageSentCopyWith<$Res> {
  _$ChatMessageSentCopyWithImpl(this._self, this._then);

  final ChatMessageSent _self;
  final $Res Function(ChatMessageSent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(ChatMessageSent(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatMarkedAsRead implements ChatEvent {
  const ChatMarkedAsRead();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMarkedAsRead);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.markedAsRead()';
}


}




/// @nodoc


class ChatMessagesReceived implements ChatEvent {
  const ChatMessagesReceived(final  List<ChatMessage> messages): _messages = messages;
  

 final  List<ChatMessage> _messages;
 List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessagesReceivedCopyWith<ChatMessagesReceived> get copyWith => _$ChatMessagesReceivedCopyWithImpl<ChatMessagesReceived>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessagesReceived&&const DeepCollectionEquality().equals(other._messages, _messages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'ChatEvent.messagesReceived(messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ChatMessagesReceivedCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatMessagesReceivedCopyWith(ChatMessagesReceived value, $Res Function(ChatMessagesReceived) _then) = _$ChatMessagesReceivedCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages
});




}
/// @nodoc
class _$ChatMessagesReceivedCopyWithImpl<$Res>
    implements $ChatMessagesReceivedCopyWith<$Res> {
  _$ChatMessagesReceivedCopyWithImpl(this._self, this._then);

  final ChatMessagesReceived _self;
  final $Res Function(ChatMessagesReceived) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,}) {
  return _then(ChatMessagesReceived(
null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}


}

/// @nodoc


class ChatStreamError implements ChatEvent {
  const ChatStreamError(this.message);
  

 final  String message;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStreamErrorCopyWith<ChatStreamError> get copyWith => _$ChatStreamErrorCopyWithImpl<ChatStreamError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStreamError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent.streamError(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatStreamErrorCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatStreamErrorCopyWith(ChatStreamError value, $Res Function(ChatStreamError) _then) = _$ChatStreamErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatStreamErrorCopyWithImpl<$Res>
    implements $ChatStreamErrorCopyWith<$Res> {
  _$ChatStreamErrorCopyWithImpl(this._self, this._then);

  final ChatStreamError _self;
  final $Res Function(ChatStreamError) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatStreamError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState()';
}


}

/// @nodoc
class $ChatStateCopyWith<$Res>  {
$ChatStateCopyWith(ChatState _, $Res Function(ChatState) __);
}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatInitial value)?  initial,TResult Function( ChatLoading value)?  loading,TResult Function( ChatLoaded value)?  loaded,TResult Function( ChatError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial(_that);case ChatLoading() when loading != null:
return loading(_that);case ChatLoaded() when loaded != null:
return loaded(_that);case ChatError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatInitial value)  initial,required TResult Function( ChatLoading value)  loading,required TResult Function( ChatLoaded value)  loaded,required TResult Function( ChatError value)  error,}){
final _that = this;
switch (_that) {
case ChatInitial():
return initial(_that);case ChatLoading():
return loading(_that);case ChatLoaded():
return loaded(_that);case ChatError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatInitial value)?  initial,TResult? Function( ChatLoading value)?  loading,TResult? Function( ChatLoaded value)?  loaded,TResult? Function( ChatError value)?  error,}){
final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial(_that);case ChatLoading() when loading != null:
return loading(_that);case ChatLoaded() when loaded != null:
return loaded(_that);case ChatError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String matchId,  List<ChatMessage> messages,  bool isSending)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial();case ChatLoading() when loading != null:
return loading();case ChatLoaded() when loaded != null:
return loaded(_that.matchId,_that.messages,_that.isSending);case ChatError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String matchId,  List<ChatMessage> messages,  bool isSending)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ChatInitial():
return initial();case ChatLoading():
return loading();case ChatLoaded():
return loaded(_that.matchId,_that.messages,_that.isSending);case ChatError():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String matchId,  List<ChatMessage> messages,  bool isSending)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial();case ChatLoading() when loading != null:
return loading();case ChatLoaded() when loaded != null:
return loaded(_that.matchId,_that.messages,_that.isSending);case ChatError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChatInitial implements ChatState {
  const ChatInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.initial()';
}


}




/// @nodoc


class ChatLoading implements ChatState {
  const ChatLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.loading()';
}


}




/// @nodoc


class ChatLoaded implements ChatState {
  const ChatLoaded({required this.matchId, required final  List<ChatMessage> messages, this.isSending = false}): _messages = messages;
  

 final  String matchId;
 final  List<ChatMessage> _messages;
 List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  bool isSending;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatLoadedCopyWith<ChatLoaded> get copyWith => _$ChatLoadedCopyWithImpl<ChatLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLoaded&&(identical(other.matchId, matchId) || other.matchId == matchId)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.isSending, isSending) || other.isSending == isSending));
}


@override
int get hashCode => Object.hash(runtimeType,matchId,const DeepCollectionEquality().hash(_messages),isSending);

@override
String toString() {
  return 'ChatState.loaded(matchId: $matchId, messages: $messages, isSending: $isSending)';
}


}

/// @nodoc
abstract mixin class $ChatLoadedCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ChatLoadedCopyWith(ChatLoaded value, $Res Function(ChatLoaded) _then) = _$ChatLoadedCopyWithImpl;
@useResult
$Res call({
 String matchId, List<ChatMessage> messages, bool isSending
});




}
/// @nodoc
class _$ChatLoadedCopyWithImpl<$Res>
    implements $ChatLoadedCopyWith<$Res> {
  _$ChatLoadedCopyWithImpl(this._self, this._then);

  final ChatLoaded _self;
  final $Res Function(ChatLoaded) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? messages = null,Object? isSending = null,}) {
  return _then(ChatLoaded(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ChatError implements ChatState {
  const ChatError(this.message);
  

 final  String message;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatErrorCopyWith<ChatError> get copyWith => _$ChatErrorCopyWithImpl<ChatError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatErrorCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ChatErrorCopyWith(ChatError value, $Res Function(ChatError) _then) = _$ChatErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatErrorCopyWithImpl<$Res>
    implements $ChatErrorCopyWith<$Res> {
  _$ChatErrorCopyWithImpl(this._self, this._then);

  final ChatError _self;
  final $Res Function(ChatError) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
