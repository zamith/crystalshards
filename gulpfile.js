var gulp = require('gulp'),
    sass = require('gulp-sass'),
    neat = require('node-neat').includePaths;

gulp.task('sass', function () {
  return gulp
    .src('assets/stylesheets/**/*.sass')
    .pipe(sass({ includePaths: ['styles'].concat(neat), indentedSyntax: true }))
    .pipe(gulp.dest('public/css'));
});

gulp.task('default', function() {
  gulp.start('sass');
});
