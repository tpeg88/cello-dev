Tracker.Views.IterationShow = Tracker.Views.CompositeView.extend({
  tagName: 'div',
  className: 'iteration-show clearfix',
  template: JST['iterations/show'],
  render: function () {
    this.$el.html(this.template({
      iteration: this.model
    }));
    
    this.storiesSortable();
    
    this.attachSubviews();
    
    return this;
  },
  initialize: function () {
    var view = this;
    this.$el.attr('data-iteration-id', this.model.id);
    // this.storySelector = '.story-show[data-iteration-id="' + this.model.id + '"]'
    this.listenTo(this.model, 'reList', this.reList)
    _.each(this.storyList(), function (story) {
      view.addStory(story);
    });
  },
  events: {
    'click .iteration-toggle': 'toggleIteration',
    'dblclick .iteration-header': 'toggleIteration',
  },
  storyList: function () {
    var id = this.model.id
    this._storyList = this._storyList ||
        this.collection.filter(function(story) {
          return story.get('iteration_id') === id;
        });
    return this._storyList
  },
  reList: function () {
    this._storyList = undefined;
    this.storyList();
  },
  toggleIteration: function () {
    this.$('.iteration-toggle').toggleClass('glyphicon-chevron-right glyphicon-chevron-down');
    this.$('.story-views').toggleClass('show hide');
  },
  addStory: function (story) {
    var storyView = new Tracker.Views.StoryShow({
      model: story,
      collection: this.collection
    });

    this.addStoryShow(storyView);
  },
  addStoryShow: function (subview) {
    this.addSubview('.story-views', subview);
  },
  removeStory: function (story) {
    storyView = _.find(this.subviews('.story-views'), function (subview) {
      return subview.model.id === story.id;
    });
    // this.removeStoryShow(storyView);
    this.reList();
  },
  removeStoryShow: function (subview) {
    this.removeSubview('.story-views', subview);
  },
  findSiblingRank: function (id, pos) {
    var $stories = $('.story-show')
    console.log($stories.index('[data-id="' + id + '"]'))
  },
  storiesSortable: function () {
    var storyId, story, oldPanelTitle, newPanelTitle, newRank, oldIterationId, newIterationId;
    var view = this;
  
    this.$('.story-views').sortable({
      connectWith: '.story-views:not(.done)',
      tolerance: 'pointer',
      items: '.story-show:not(.accepted)',
      start: function (event, ui) {
        storyId = ui.item.attr('data-id');
        story = view.collection.get(storyId);
        newPanelTitle = oldPanelTitle = ui.item.parents('.panel').attr('id');
        newIterationId = oldIterationId= ui.item.parents('.iteration-show').attr('data-iteration-id');
      },
      receive: function (event, ui) {
        newPanelTitle = ui.item.parents('.panel').attr('id');
        newIterationId = ui.item.parents('.iteration-show').attr('data-iteration-id');
      },
      // stop is fired in the original container view and will occur after recieve is fired if the story is moved to a different list
      stop: function (event, ui) {
        itemIndex = ui.item.index('.story-show')

        var prevRank = ui.item.prev('.story-show').data('rank') ||
            $($('.story-show')[itemIndex - 1]).data('rank');
        var postRank = ui.item.next('.story-show').data('rank') ||
            $($('.story-show')[itemIndex + 1]).data('rank');
        if (!prevRank || prevRank < 0) { prevRank = 0; }
        if (!postRank || postRank < 0) { postRank = prevRank + 1; }
        
        if (story.get('iteration_id') !== newIterationId) {
          story.set('iteration_id', newIterationId);
        }
        
        newRank = ((prevRank + postRank) / 2);
        story.save({story_rank: newRank});
      },
    });
  }
});